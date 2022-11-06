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
    
/// function to hide the intricates of the URL Stats API from the user
    func deleteTag(_ tag: FSNM.Tag, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        let request = HTTPRequest(api: .delete, for: tag, having: token)

        fetchFSNMString(request: request, response: String.self) { result in
            completion(result)
            return
        }
    }
    
}
