//
//  FSNMPing.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//
// upload

import Foundation
//
//  Extensions for the Ping API
//
extension FSNM {
/** the datastructure retrieved for a 200-reponse. FSNM.Ping has only one variable ping (String), which will contain a timestamp put by the folksonomy server.
*/
    public struct Ping: Codable, Equatable {
        var ping: String?
    }
    

}

extension URLSession {
    
/**
Function to check whether the folksonomy server is available.

- returns:
A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Ping struct and for the failure an Error. FSNM.Ping has only one variable ping (String), which will contain a timestamp put by the folksonomy server.
*/
    func FSNMping(completion: @escaping (_ result: Result<FSNM.Ping, FSNMError>) -> Void) {
        fetch(request: HTTPRequest(api: .ping), responses: [200:FSNM.Ping.self]) { (result) in
            completion(result)
            return
        }
    }
}
