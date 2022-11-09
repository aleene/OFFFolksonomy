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
    /// the datastructure retrieved for reponse 200
    public struct Auth: Codable {
        var access_token: String?
        var token_type: String?
    }
}

extension URLSession {
    
/**
 Function to retrieve an authentication token for a username/password combination.
 - Parameters:
    - username: the username of the user as registered on OpenFoodFacts
    - password: the corresponding password
 - Returns:
 A Result enum, with either a succes Auth Struct or an Error. The Auth Struct has the variables: **access_token** (String), which has to be passed on in other API calls; **token_type** (String).
*/
    func FSNMauth(username: String, password: String, completion: @escaping (_ postResult: Result<FSNM.Auth, FSNMError>) -> Void) {
        fetch(request: HTTPRequest(username: username, password: password), responses: [200:FSNM.Auth.self]) { (result) in
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
