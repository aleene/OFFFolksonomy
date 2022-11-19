//
//  FSNMStats.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//
// upload

import Foundation

//
//  Extensions for the Stats API
//
extension FSNM {
        
    /// the datastructure retreived for a succesfull reponse 200
    public struct Stats: Codable, Identifiable, Equatable {
        public var product: String?
        public var keys: Int?
        public var last_edit: String?
        public var editors: Int?
        
        public var id: String { last_edit! }
    }
    
}

extension URLSession {
    
/**
Retrieves a list of products for a key and/or value and/or owner.
 
 - parameters:
    - key: the key of the tag for which the statistics must be searched
    - value : the key of the tag for which the statistics must be searched
    - owner: the owner of the tag
    - token: the token, obtained via the Auth API
 - returns:
   A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Stats struct and for the failure an Error. The FSNM.Stats struct has three variables: *product* (String), the barcode of the product; *keys* (Int), the number of keys associated with the product; *last_edit* (String), the last edit date; *editors*: the number of editors associated with the product.

*/
    func FSNMstats(with key: String?, and value: String?, for owner: String?, has token: String?, completion: @escaping (_ result: Result<[FSNM.Stats], FSNMError> ) -> Void) {
        let request = HTTPRequest(api: .productsStats, for: nil, with: key, and: value, by: owner, having: token)
        fetchFSNMArray(request: request, response: FSNM.Stats.self) { result in
            completion(result)
            return
        }
    }

}
