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

extension OFFAPI {
    
    /// function to hide the intricates of the URL API from the user
    func fetchAuth(completion: @escaping (_ postResult: Result<FSNM.Auth, Error>) -> Void) {
        fetch(url: URL.FSNMAuthURL(), responses: [200:FSNM.Auth.self]) { (result) in
            completion(result)
            return
        }
    }
}

extension URL {

/// Convienience URL to check whether the folksonomy server responds
    public static func FSNMAuthURL() -> URL {
        return FSNMAuthURL(for: .food)
    }
    
    private static func FSNMAuthURL(for productType: OFFProductType) -> URL {
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Auth
        assert(URL(string: url) != nil, "URL:folksonomyAuth: url is nil")
        return URL(string: url)!
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
