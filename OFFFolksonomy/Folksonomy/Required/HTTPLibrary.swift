//
//  HTTPLibrary.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 25/10/2022.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public struct HTTPRequest {
    private var urlComponents = URLComponents()
    public var method: HTTPMethod = .get
    public var headers: [String:String] = [:]
    public var body: HTTPBody = EmptyBody()
    
    public init() {
        self.urlComponents.scheme = "https"
    }
    
    public var url: URL? { urlComponents.url }
}

public extension HTTPRequest {
    
    var scheme: String { urlComponents.scheme ?? "https" }
    
    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }
    
    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
    
    var queryItems: [URLQueryItem] {
        get { urlComponents.queryItems != nil ? urlComponents.queryItems! : [] }
        set { urlComponents.queryItems = newValue }
    }
}

public struct HTTPResponse {
    public let request: HTTPRequest
    public let response: HTTPURLResponse
    public let body: Data?
    
    public var status: HTTPStatus {
        HTTPStatus(rawValue: response.statusCode) ?? .unknown
    }
    
    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }
    
    public var headers: [AnyHashable: Any] { response.allHeaderFields }
}

public enum HTTPStatus: Int {
    case success = 200
    case notFound = 404
    case validationError = 422
    case internalServerError = 500
    case notImplemented = 501
    case unknown
}

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    
    public var request: HTTPRequest {
        switch self {
        case .success(let response): return response.request
        case .failure(let error): return error.request
        }
    }
    
    public var response: HTTPResponse? {
        switch self {
        case .success(let response): return response
        case .failure(let error): return error.response
        }
    }
}

public struct HTTPError: Error {
    public let code: Code
    public let request: HTTPRequest
    public let response: HTTPResponse?
    public let underlyingError: Error?
    
    public enum Code {
        case invalidRequest
        case cannotConnect
        case cancelled
        case insecureConnection
        case invalidResponse
        case unknown
    }
}

public protocol HTTPBody {
    var isEmpty: Bool { get }
    var additionalHeaders: [String:String] { get }
    func encode() throws -> Data
}

extension HTTPBody {
    public var isEmpty: Bool { return false }
    public var additionalHeaders: [String:String] { return [:] }
}


public struct EmptyBody: HTTPBody {
    public let isEmpty = true
    
    public init() { }
    
    public func encode() throws -> Data { Data() }
}

//              NOT USED
//public struct DataBody: HTTPBody {
//    private let data: Data
//
//    public var isEmpty: Bool { data.isEmpty }
//    public var additionalHeaders: [String:String]
//
//    public init(_ data: Data, additionalHeaders: [String:String] = [:]) {
//        self.data = data
//        self.additionalHeaders = additionalHeaders
//    }
//
//    public func encode() throws -> Data { data }
//}

public struct FormBody: HTTPBody {
    public var isEmpty: Bool { values.isEmpty }
    public let additionalHeaders = ["Content-Type":"application/x-www-form-urlencoded"]

    private let values: [URLQueryItem]

    public init(_ values: [URLQueryItem]) {
        self.values = values
    }

    public init(_ values: [String: String]) {
        let queryItems = values.map {
            URLQueryItem(name:$0.key, value: $0.value)
        }
        self.init(queryItems)
    }

    public func encode() throws -> Data {
        let pieces = values.map(self.urlEncode)
        let bodyString = pieces.joined(separator: "&")
        return Data(bodyString.utf8)
    }

/// Encode the name value combination
    private func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }

/// Encode characters to percent-encoding
    private func urlEncode(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
}

public struct JSONBody: HTTPBody {

    public let isEmpty: Bool = false
    public var additionalHeaders = ["Content-Type" : "application/json; charset=utf8"]

    private let encoder: () throws -> Data

    public init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder() ) {
        self.encoder = { try encoder.encode(value) }
    }
    public func encode() throws -> Data {
        return try encoder()
    }
}

public protocol HTTPLoading {
    
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
    
    // function to do additional decoding of a succesfully received json
    func fetch<T: Decodable> (request: HTTPRequest, responses: [Int:T.Type], completion: @escaping (_ result: Result<T, Error>) -> Void)

    func fetchArray<T1:Decodable, T2:Decodable> (request: HTTPRequest, responses: ([Int:T1.Type], [Int:T2.Type]), completion: @escaping (_ result: (Result<[T1], Error>?, Result<T2, Error>?) ) -> Void)

}

extension URLSession: HTTPLoading {
    
    public func fetch<T>(request: HTTPRequest, responses: [Int : T.Type], completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
        load(request: request) { result in
            switch result {
            case .success(let response):
                if let responsetype = responses[response.status.rawValue] {
                    OFFAPI.decode(data: response.body, type: responsetype) { result in
                        completion(result)
                        return
                    }
                } else {
                    completion(.failure(APIResponseError.dataNil))
                    return
                    // unsupported response type
                }
            case .failure(_):
                // the original response failed
                completion(.failure(APIResponseError.dataNil))
                return
            }
        }
    }
    
    public func fetchArray<T1:Decodable, T2:Decodable> (request: HTTPRequest, responses: ([Int:T1.Type], [Int:T2.Type]), completion: @escaping (_ result: (Result<[T1], Error>?, Result<T2, Error>?) ) -> Void) {
        
        guard let response0 = responses.0.first else {
            completion( (Result.failure(APIResponseError.parsing), nil) )
            return
        }
        guard let response1 = responses.1.first else {
            completion( (Result.failure(APIResponseError.parsing), nil) )
            return
        }

        load(request: request) { result in
            switch result {
            case .success(let response):
                if response0.key == response.status.rawValue {
                    print("fetchArray: response: \(response.status.rawValue)")
                    OFFAPI.decodeArray(data: response.body, type: response0.value) { result in
                        completion( (result, nil) )
                        return
                    }
                } else if response1.key == response.status.rawValue {
                    OFFAPI.decode(data: response.body, type: response1.value) { result in
                        completion( (nil, result) )
                        return
                    }

                } else {
                    // unsupported response type
                    print("fetchArray: unsupported response: \(response.status.rawValue)")
                    completion( (Result.failure(APIResponseError.unsupportedSuccessResponseType), nil) )
                    return
                }
            case .failure(let error):
                // the original response failed
                completion( (Result.failure(error), nil) )
                return
            }
        }

    }

    
    public func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        
        guard let url = request.url else {
            let error = HTTPError(code: .invalidRequest, request: request, response: nil, underlyingError: nil)
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        if !request.body.isEmpty {
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }
            
            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
               // completion(.failure)
                return
            }
        }
        
        let dataTask = dataTask(with: urlRequest) { (data, urlResponse, error) in
            do {
                // Check if any error occured.
                if let error = error { throw error }
        
                // Check response code and handle each possible responses
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    let response = HTTPResponse(request: request, response: httpResponse, body: data)
                    completion(.success(response))
                } else {
                    let error = HTTPError(code: .invalidResponse, request: request, response: nil, underlyingError: nil)
                    completion(.failure(error))
                }
            } catch {
                let error = HTTPError(code: .invalidRequest, request: request, response: nil, underlyingError: nil)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}

public class MockLoader: HTTPLoading {
    
    public func fetchArray<T1, T2>(request: HTTPRequest, responses: ([Int : T1.Type], [Int : T2.Type]), completion: @escaping ((Result<[T1], Error>?, Result<T2, Error>?)) -> Void) where T1 : Decodable, T2 : Decodable {
        
    }
    
    
    public func fetch<T>(request: HTTPRequest, responses: [Int : T.Type], completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
    }
    
    
    public func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        let urlResponse = HTTPURLResponse(url: request.url!, statusCode: HTTPStatus.success.rawValue, httpVersion: "1.1", headerFields: nil)!
        let response = HTTPResponse(request: request, response: urlResponse, body: nil)
        completion(.success(response))
    }
}

