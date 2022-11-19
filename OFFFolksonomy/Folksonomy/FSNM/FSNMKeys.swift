//
//  FSNMKeys.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//
// upload

import Foundation
//
//  Extensions for the Keys API
//
extension FSNM {
        
    /// the datastructure retreived for a succesfull reponse 200
    public struct Key: Codable, Identifiable {
        public var k: String?
        public var count: Int?
        public var values: Int?
        
        public var id: String { k! }
    }
    
}

extension URLSession {
    
/**
Retrieves the list of all keys on the folksonomy server with statistics.

- returns:
  A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Keys struct and for the failure an Error. The FSNM.Keys struct has three variables: *k* (String), the name of the key; *count* (Int), the number of occurences; *values* (Int), the number of associated values.
  */
    func FSNMkeys(completion: @escaping (_ result: (Result<[FSNM.Key], FSNMError>) ) -> Void) {
        // create the correct url
        let request = HTTPRequest(api: .keys)
        
        fetchFSNMArray(request: request, response: FSNM.Key.self) {
            result in
            completion(result)
            return
        }
    }
    
}
