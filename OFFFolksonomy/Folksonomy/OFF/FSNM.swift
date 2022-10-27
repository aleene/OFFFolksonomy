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
        case productsStats
        
        var path: String {
            switch self {
            case .auth: return "/auth"
            case .ping: return "/ping"
            case .productsStats: return "/products/stats"
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

extension URLSession {
   
/// An alternative name URLSession to make clear all usage must be related to FSNM
    typealias FSNMSession = URLSession

/**
Generic function for multiple FSNM API's. Most of these API's can return two succesfull response codes. It is assumed that all successful calls that return the data have response code 200 and the successful calls that return an error have response code 422.
*/
    func fetchFSNMArray<T:Decodable> (request: HTTPRequest, response: T.Type, completion: @escaping (_ result: (Result<[T],Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        
        fetchArray(request: request, responses: ( [200:T.self], [422:FSNM.ValidationError.self]) ) { result in
            completion(result)
            return
        }
    }
}

extension HTTPRequest {
    
    typealias FSNMRequest = HTTPRequest

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
    
/**
Init for the food folksonomy API. This will setup the correct host and path of the API URL and  a  query
- Parameters:
 - api: the api required (i.e. .auth, .ping, etc).
 - key: the key part of the query, i.e. the tag that must be searched for.
*/
    init(api: FSNM.APIs, with key: String?, and value: String?, for owner: String?, has token: String?) {
        self.init(api: api)
        switch api {
        // https://api.folksonomy.openfoodfacts.org/products/stats?k=ANEXISTINGKEY&value=ANEXISTINGVALUE
        case .productsStats:
            // also add the Auhorization token header
            if owner != nil,
            let validToken = token {
                self.headers["Authorization"] = "Bearer \(validToken)"
            }
            var queryItems: [URLQueryItem] = []
            if key != nil {
                queryItems.append(URLQueryItem(name: "k", value: key))
            }
            if value != nil {
                queryItems.append(URLQueryItem(name: "v", value: value))
            }
            if owner != nil {
                queryItems.append(URLQueryItem(name: "owner", value: owner))
            }
            self.queryItems = queryItems
        default:
            print("FSNMRequest: this API does not support a key query.")
        }
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
