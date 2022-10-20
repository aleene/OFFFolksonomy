//
//  FSNMProductTagVersions.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import Foundation

//
//  Extensions for the Product Tag Versions API
//
extension FSNMAPI {
        
    /// the datastructure retreived for a succesful reponse 200
    public struct ProductTagVersions: Decodable, Identifiable {
        public var product: String?
        public var k: String?
        public var v: String?
        public var version: Int?
        public var editor: String?
        public var last_edit: String?
        public var comment: String?
        
        public var id: String { last_edit! }
    }
    
    /// Function to be used for fetching the product tag versions
    public func fetchProductTagVersions(for barcode: OFFBarcode, with key: String, completion: @escaping (_ postResult: Result<[ProductTagVersions], Error>) -> Void) {
        let versions: [ProductTagVersions] = []
        fetchProductTagVersions(url: URL.FSNMProductTagVersionsURL(with: barcode, and: key), responses: [200:versions]) { (result) in
            completion(result)
            return
        }
    }
    
    // The intention is to have a generic function that can read any json array
    private func fetchProductTagVersions (url: URL, responses: [Int:[FSNMAPI.ProductTagVersions]], completion: @escaping (_ result: Result<[FSNMAPI.ProductTagVersions], Error>) -> Void) {
       
        func parse(data: Data?, type: [FSNMAPI.ProductTagVersions]) -> Result<[FSNMAPI.ProductTagVersions], Error> {
            do {
                if let responseData = data {
                    let decoded = try JSONDecoder().decode([FSNMAPI.ProductTagVersions].self, from: responseData)
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
                    if let responsetype = responses[httpResponse.statusCode] {
                        let klaar = parse(data:data, type: responsetype)
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

extension URL {

/// Convienience URL to get versions of a key of a product
    public static func FSNMProductTagVersionsURL(with barcode: OFFBarcode, and key: String) -> URL {
        return FSNMProductTagVersionsURL(for: .food, with: barcode, and: key, by: nil)
    }

/// Convienience URL to get versions of a key of a product for an owner
    public static func FSNMProductTagVersionsURL(with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {
        return FSNMProductTagVersionsURL(for: .food, with: barcode, and: key, by: owner)
    }

}
