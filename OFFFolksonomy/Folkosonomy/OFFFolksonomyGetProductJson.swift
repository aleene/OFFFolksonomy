//
//  OFFFolksonomyGetProductJson.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//
/**
 
 - Example:
 [ { "product": "string",
     "k": "string",
     "v": "string",
     "owner": "",
     "version": 1,
     "editor": "string",
     "last_edit": "2022-10-13T15:54:16.929Z",
     "comment": ""  } ,
    { "product": "string",
     "k": "string",
     "v": "string",
     "owner": "",
     "version": 1,
     "editor": "string",
     "last_edit": "2022-10-13T15:54:16.929Z",
     "comment": ""  }]
 */
//import Foundation
//class OFFFolksonomyGetProductJson: Codable {
//    var properties: [OFFFolksonomyGetProductPropertyJson]?
//
//}

class OFFFolksonomyGetProductPropertyJson: Codable, Identifiable {
    var product: String?
    var k: String?
    var v: String?
    var owner: String?
    var version: Int?
    var editor: String?
    var last_edit: String?
    var comment: String?
}

/**
 Error response status 401 json for folksonomyStats(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?) -> URL
 
 Example:
 {  "detail": "Authentication required for 'aleene'"  }

 */
class FSNMProductSStats401: Codable, Identifiable {
    var detail: String?
}

/**
 Success response status 200 json for folksonomyStats(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?) -> URL

 Example
 [ {
     "product": "string",
     "keys": 0,
     "editors": 0,
     "last_edit": "2022-10-17T14:25:00.642Z"
   }  ]

 */
class FSNMProductSStats200: Codable, Identifiable {
    var product: String?
    var keys: Int?
    var editors: Int?
    var date: String?
}

/**
 Validation error response status 422 json for folksonomyStats(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?) -> URL

 Example
 {
   "detail": [
     {
       "loc": [
         "string"
       ],
       "msg": "string",
       "type": "string"
     } ] }

 */
class FSNMProductsStats422: Codable, Identifiable {
    var detail: [FSNMProductsStats422Detail] = []
}

class FSNMProductsStats422Detail: Codable, Identifiable {
    var loc: [String] = []
    var msg: String?
    var type: String?
}

