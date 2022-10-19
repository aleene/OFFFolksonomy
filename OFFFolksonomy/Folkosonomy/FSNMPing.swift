//
//  FSNMPing.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import Foundation
//
//  Extensions for the Ping API
//
extension FSNMAPI {
    /// the datastructure retreived for reponse 200
    public struct Ping: Decodable {
        var ping: String?
    }
    
    /// function to hide the intricates of the URL API from the user
    public func fetchPing(completion: @escaping (_ postResult: Result<Ping, Error>) -> Void) {
        fetch(url: URL.FSNMPingURL(), responses: [200:Ping.self]) { (result) in
            completion(result)
            return
        }
    }
}

extension URL {

/// Convienience URL to check whether the folksonomy server responds
    public static func FSNMPingURL() -> URL {
        return folksonomyPing(with: .food)
    }

}
