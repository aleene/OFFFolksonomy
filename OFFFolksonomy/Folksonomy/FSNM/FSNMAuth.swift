//
//  FSNMAuth.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 24/10/2022.
//

import Foundation
//
//  Extensions for the Auth API
//
extension FSNM {
    /// the datastructure retreived for reponse 200
    public struct Auth: Codable {
        var access_token: String?
        var token_type: String?
    }
}

extension URLSession {
    
    /// function to hide the intricates of the URL API from the user
    func fetchAuth(username: String, password: String, completion: @escaping (_ postResult: Result<FSNM.Auth, Error>) -> Void) {
        fetch(request: HTTPRequest(username: username, password: password), responses: [200:FSNM.Auth.self]) { (result) in
            completion(result)
            return
        }
    }
}

extension HTTPLoading {
    
    func fetchAuth(completion: @escaping (_ result:Result<FSNM.Auth, Error>) -> Void) {
        fetch(request: HTTPRequest(api: .auth), responses: [200:FSNM.Auth.self]) { (result) in
            completion(result)
            return
        }
    }
}

extension HTTPRequest {
    
/**
 Initialised the request for the Auth-API
- Parameters:
    - username: the username of the user as registered on OFF.
    - password: the password of the user as registerd on OFF.
    
 - Example:
 curl -X 'POST' \
 'https://api.folksonomy.openfoodfacts.org/auth' \
 -H 'accept: application/json' \
 -H 'Content-Type: application/x-www-form-urlencoded' \
 -d 'grant_type=&username=XXXX&password=YYYYY&scope=&client_id=&client_secret='

*/
    init(username: String, password: String) {
        self.init(api: .auth)
        self.headers["accept"] = "application/json"
        
        self.method = .post
        let body = FormBody(["grant_type": "",
                             "username": "\(username)",
                             "password": "\(password)",
                             "client_id": "",
                             "client_secret": ""])
        self.body = body
    }
}
