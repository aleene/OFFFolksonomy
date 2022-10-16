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

