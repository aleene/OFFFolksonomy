//
//  FSNMAPI.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 21/10/2022.
//

import Foundation


struct FSNMAPI {

/**
 Some API's (ProductStats) can return a validation error with response code 422.
 */
    public struct ValidationError: Codable {
        var detail: ValidationErrorDetail?
    }
    
    public struct ValidationErrorDetail: Codable {
        var loc: [String] = []
        var msg: String?
        var type: String?
    }
    
}

extension OFFAPI {
/**
Generic function for multiple FSNM API's. Most of these API's can return two succesfull response codes. It is assumed that all successful calls that return the data have response code 200 and the successful calls that return an error have response code 422.
 */
    func fetchArray<T:Decodable> (url: URL, response: T.Type, completion: @escaping (_ result: (Result<[T], Error>?, Result<FSNMAPI.ValidationError, Error>?) ) -> Void) {
        fetchArray(url: url, responses: ( [200:T.self], [422:FSNMAPI.ValidationError.self]) ) { result in
            completion(result)
            return
        }
    }
}
