//
//  FSNMHello.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 05/11/2022.
//

import Foundation
//
//  Extensions for the Hello API
//
extension FSNM {
/// the datastructure retrieved for reponse 200 for the Hello API
    public struct Hello: Codable {
        var message: String?
    }
}

extension URLSession {
    
/**
 Function to check whether the folksonomy server is available.

- returns:
 A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Hello struct and for the failure an Error.
*/
    func FSNMhello(completion: @escaping (_ result: Result<FSNM.Hello, FSNMError>) -> Void) {
        fetch(request: HTTPRequest(api: .hello), responses: [200:FSNM.Hello.self]) { (result) in
            completion(result)
            return
        }
    }
}
