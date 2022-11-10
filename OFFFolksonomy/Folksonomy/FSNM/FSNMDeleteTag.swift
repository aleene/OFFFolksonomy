//
//  FSNMDeleteTag.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 05/11/2022.
//

import Foundation

extension FSNM {
    
/// the datastructure retreived for a succesful response 200
    public struct DeleteResponse: Codable, Identifiable {
        public var response: String?
        
        public var id: String { response! }
    }
    
}
extension URLSession {
    
/**
Deletes a tag of a product.
             
- Parameters:
 - product: the FSNM tag to be deleted
 - owner: the tag owner
 - token: the token of the user (get the token via the Auth API)
             
- returns:
A completion block with a Result enum (success or failure). The associated value for success is a string and for the failure an Error.
    */
    func FSNMdelete(_ tag: FSNM.Tag, for owner: String?, has token: String?, completion: @escaping (_ result: (Result<String, FSNMError>) ) -> Void) {
        let request = HTTPRequest(api: .delete, for: tag, having: token)

        fetchFSNMString(request: request) { result in
            completion(result)
            return
        }
    }
    
}
