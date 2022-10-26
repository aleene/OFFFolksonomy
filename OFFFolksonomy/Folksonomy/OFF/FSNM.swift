//
//  FSNMAPI.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 21/10/2022.
//

import Foundation

struct FSNM {

/** all possible FSNM API's
 */
    enum APIs {
        case auth
        case ping
        
        var path: String {
            switch self {
            case .auth: return "/auth"
            case .ping: return "/ping"
            }
        }
    }

/**
    Some API's (ProductStats) can return a validation error with response code 401.
*/
    public struct Error401: Codable {
        var detail: String?
    }
    
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

extension HTTPRequest {
/**
Init for all producttypes supported by OFF. This will setup the correct host and path of the API URL
 
 - Parameters:
    - productType: one of the productTypes (.food, .beauty, .petFood, .product);
    - api: the api required (i.e. .auth, .ping, etc)
*/
    init(for productType: OFFProductType, for api: FSNM.APIs) {
        self.init()
        self.host = URL.FSNMHost(for: productType)
        self.path = api.path
    }
    
/**
 Init for the food folksonomy API. This will setup the correct host and path of the API URL
  
 - Parameters:
     - api: the api required (i.e. .auth, .ping, etc)
 */
    init(api: FSNM.APIs) {
        self.init()
        self.host = URL.FSNMHost(for: .food)
        self.path = api.path
    }
    

}

extension OFFAPI {
/**
Generic function for multiple FSNM API's. Most of these API's can return two succesfull response codes. It is assumed that all successful calls that return the data have response code 200 and the successful calls that return an error have response code 422.
 */
    func fetchArray<T:Decodable> (url: URL, response: T.Type, completion: @escaping (_ result: (Result<[T], Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        fetchArray(url: url, responses: ( [200:T.self], [422:FSNM.ValidationError.self]) ) { result in
            completion(result)
            return
        }
    }
}
