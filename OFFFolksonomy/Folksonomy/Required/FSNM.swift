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
        case keys
        case ping
        case post
        case products
        case productsStats
        case productTagVersions
        case tags
        
        var path: String {
            switch self {
            case .auth: return "/auth"
            case .keys: return "/keys"
            case .ping: return "/ping"
            case .post: return "/post"
            case .products: return "/products"
            case .productsStats: return "/products/stats"
            case .productTagVersions: return "/product" // needs to be extended with /<barcode>/<key>/versions
            case .tags: return "/product" // needs to be extended with /<barcode>
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
    
/**
Init for all producttypes supported by OFF. This will setup the correct host and path of the API URL
 
 - Parameters:
    - productType: one of the productTypes (.food, .beauty, .petFood, .product);
    - api: the api required (i.e. .auth, .ping, etc)
*/
    init(for productType: OFFProductType, for api: FSNM.APIs) {
        self.init()
        self.host = productType.host
        self.path = api.path
    }
    
/**
 Init for the food folksonomy API. This will setup the correct host and path of the API URL
  
- Parameters:
 - api: the api required (i.e. .auth, .ping, etc)
 */
    init(api: FSNM.APIs) {
        self.init()
        self.host = OFFProductType.food.host
        self.path = api.path
    }
    
/**
Init for the food folksonomy API. This will setup the correct host and path of the API URL and  a  query
- Parameters:
 - api: the api required (i.e. .auth, .ping, etc).
 - key: the key part of the query, i.e. the tag that must be searched for.
*/
    init(api: FSNM.APIs, for product: String?, with key: String?, and value: String?, by owner: String?, having token: String?) {
        self.init(api: api)
        switch api {
        case .keys:
            if owner != nil {
                var queryItems: [URLQueryItem] = []
                if owner != nil {
                    queryItems.append(URLQueryItem(name: "owner", value: owner))
                }
                self.queryItems = queryItems
            }
        // https://api.folksonomy.openfoodfacts.org/products/stats?k=ANEXISTINGKEY&value=ANEXISTINGVALUE
        case .products, .productsStats:
            // also add the Authorization token header
            if owner != nil,
               let validToken = token {
                self.headers["Authorization"] = "Bearer \(validToken)"
            }
            // Check if any query element is there. Otherwise an empty ? will be added.
            if key != nil || value != nil || owner != nil {
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
            }
        case .productTagVersions:
            if let validProduct = product,
               let validKey = key {
                self.path = api.path + "/" + "\(validProduct)" + "/" + "\(validKey)" + "/versions"
                // Check if any query element is there. Otherwise an empty ? will be added.
                if owner != nil {
                    var queryItems: [URLQueryItem] = []
                    if owner != nil {
                        queryItems.append(URLQueryItem(name: "owner", value: owner))
                    }
                    self.queryItems = queryItems
                }
            }
        case .tags:
            if let validProduct = product  {
                self.path = api.path + "/" + "\(validProduct)"
                // Check if any query element is there. Otherwise an empty ? will be added.
                if owner != nil {
                    var queryItems: [URLQueryItem] = []
                    if owner != nil {
                        queryItems.append(URLQueryItem(name: "owner", value: owner))
                    }
                    self.queryItems = queryItems
                }
            }

        default:
            print("HTTPRequest: this API does not support a query.")
        }
    }
    
    init(api: FSNM.APIs, for tag: FSNM.ProductTags, having token: String?) {
        self.init(api: api)
        switch api {
        case .post:
            // add the Authorization token header
            if tag.editor != nil,
               let validToken = token {
                self.headers["Authorization"] = "Bearer \(validToken)"
            }
            self.body = JSONBody(tag)
        default:
            print("HTTPRequest:init(api:for:having:) - not a post api)")
        }

    }
    
}
