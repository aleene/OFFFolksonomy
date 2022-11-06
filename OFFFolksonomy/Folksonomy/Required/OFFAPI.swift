 //
//  OpenFoodFactsRequest.swift
//  FoodViewer
//
//  Created by arnaud on 03/02/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

public class OFFAPI {
    
/// Generic function to decode a json struct
    public static func decode<T:Decodable>(data: Data?, type: T.Type, completion: @escaping (_ result: Result<T, Error>) -> Void)  {
        do {
            if let responseData = data {
                if let validString = String(data: responseData, encoding: .utf8) {
                    print(validString)
                }

                let decoded = try JSONDecoder().decode(type.self, from: responseData)
                completion(Result.success(decoded))
                return
            } else {
                completion(Result.failure(APIResponseError.dataNil))
                return
            }
        } catch {
            completion(Result.failure(APIResponseError.parsing))
            return
        }
    }

/// Generic function to decode a json array
    public static func decodeArray<T:Decodable>(data: Data?, type: T.Type, completion: @escaping (_ result: Result<[T], Error>) -> Void)  {
        do {
            if let responseData = data {
                let decoded = try JSONDecoder().decode([T].self, from: responseData)
                completion(Result.success(decoded))
                return
            } else {
                completion(Result.failure(APIResponseError.dataNil))
                return
            }
        } catch {
            completion(Result.failure(APIResponseError.parsing))
        }
    }

}

// Inspiration: https://medium.com/@dhawaldawar/how-to-mock-urlsession-using-urlprotocol-8b74f389a67a

class MockURLProtocol: URLProtocol {
  
    // 1. Handler to test the request and return mock response.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    // added via https://samwize.com/2022/07/07/how-to-use-urlprotocol-to-mock-networking-api/
    override class func canInit(with task: URLSessionTask) -> Bool {
            return true
        }

    override class func canInit(with request: URLRequest) -> Bool {
    // To check if this protocol can handle the given request.
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    // Here you return the canonical version of the request but most of the time you pass the orignal one.
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("MockURLProtocol:startLoading: handler is unavailable.")
        }
        
        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)
        
            // 3. Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
          if let data = data {
            // 4. Send received data to the client.
            client?.urlProtocol(self, didLoad: data)
            }
        
          // 5. Notify request has been finished.
          client?.urlProtocolDidFinishLoading(self)
        } catch {
          // 6. Notify received error.
          client?.urlProtocol(self, didFailWithError: error)
        }
        // added via https://samwize.com/2022/07/07/how-to-use-urlprotocol-to-mock-networking-api/
        client?.urlProtocolDidFinishLoading(self)
    }

  override func stopLoading() {
    // This is called if the request gets canceled or completed.
  }
  
}

//

public enum APIResponseError: Error {
    case network
    case parsing
    case request
    case dataNil
    case dataType
    case unsupportedSuccessResponseType
}
