 //
//  OpenFoodFactsRequest.swift
//  FoodViewer
//
//  Created by arnaud on 03/02/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

class OFFRequest {
        
    enum FetchJsonResult {
        case error(String)
        case success(Data)
    }
                
    public func fetchFolksonomyProperties(for barcode: OFFBarcode) -> FSNMFetchStatus {
        let fetchUrl = URL.folksonomyTags(for: .food, with: barcode, by: nil)
        let result = fetch(for: fetchUrl)
        switch result {
        case .success(let data):
            // print(String(data: data, encoding: .utf8) ?? "No json contents to show")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let product = try decoder.decode([OFFFolksonomyGetProductPropertyJson].self, from: data)
                return .success(product)
            } catch let error {
                print(error)
                return .failed(barcode.string)
            }

        case .error(let string):
            return .failed(string)
        }
    }

    public func fetchFSNMstats(for key: String, and value: String?, by owner: String?) -> FSNMFetchStatus {
        let fetchUrl = URL.folksonomyStats(for: .food, with: key, and: value, by: owner)
        let result = fetch(for: fetchUrl)
        switch result {
        case .success(let data):
            // print(String(data: data, encoding: .utf8) ?? "No json contents to show")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let json = try decoder.decode(FSNMProductSStats200.self, from: data)
                return .success(json)
            } catch let error {
                print(error)
                return .failed(key)
            }

        case .error(let string):
            return .failed(string)
        }
    }
    // Generic fetch function
    public func fetch(for url: URL) -> FetchJsonResult {
            do {
                let data = try Data(contentsOf: url, options: NSData.ReadingOptions.mappedIfSafe)
                
                return FetchJsonResult.success(data)
            } catch let error as NSError {
                print(error);
                // This error is show if the product does not have any properties
                return FetchJsonResult.error(error.description)
            }
    }
    
}

// Definition of additional classes, so that it is possible to test the network layer.
//
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
            fatalError("Handler is unavailable.")
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
}

struct Post: Decodable, Identifiable {
  var userId: Int? = nil
  var id: Int? = nil
  var title: String? = nil
  var body: String? = nil
    
}

class FSNMAPI {
    let urlSession: URLSession
  
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // function to hide the intricates of the URL API from the user
    public func fetchPost(completion: @escaping (_ postResult: Result<Post, Error>) -> Void) {
        fetch(url: URL(string: "https://jsonplaceholder.typicode.com/posts/42")!, responses: [200:Post.self]) { (result) in
            completion(result)
            return
        }
    }
        
    /// Generic function to be used for any API
    public func fetch<T: Decodable> (url: URL, responses: [Int: T.Type], completion: @escaping (_ result: Result<T, Error>) -> Void) {
       
        func parse<T:Decodable>(data: Data?, type: T.Type) -> Result<T, Error> {
            do {
                if let responseData = data {
                    let decoded = try JSONDecoder().decode(type.self, from: responseData)
                    print(decoded)
                    return Result.success(decoded)
                } else {
                    return Result.failure(APIResponseError.dataNil)
                }
            } catch {
                return Result.failure(APIResponseError.parsing)
            }
        }
        
        let dataTask = urlSession.dataTask(with:url) { (data, urlResponse, error) in
            do {
                // Check if any error occured.
                if let error = error {
                    throw error
                }
        
                // Check response code and handle each possible responses
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    if let responseJson = responses[httpResponse.statusCode] {
                        let klaar = parse(data:data, type: responseJson.self)
                        completion(klaar)
                        return
                   }
                } else {
                    completion(Result.failure(APIResponseError.network))
                    return
                }
            } catch {
                completion(Result.failure(error))
            }
        }
        dataTask.resume()
    }
}

