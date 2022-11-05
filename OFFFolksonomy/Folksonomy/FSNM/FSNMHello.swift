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
    /// the datastructure retrieved for reponse 200
    public struct Hello: Codable {
        var message: String?
    }
}

extension URLSession {
    
    /// function to hide the intricates of the URL API from the user
    func fetchHello(completion: @escaping (_ result: Result<FSNM.Hello, Error>) -> Void) {
        fetch(request: HTTPRequest(api: .hello), responses: [200:FSNM.Hello.self]) { (result) in
            completion(result)
            return
        }
    }
}
