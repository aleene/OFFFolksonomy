//
//  File.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//
// upload

import Foundation

//
//  Extensions for the Products API
//
extension FSNM {
        
    /// the datastructure retreived for a succesfull reponse 200
    public struct Product: Decodable, Identifiable {
        public var product: String?
        public var k: String?
        public var v: String?
        
        // required for Identifiable protocol
        public var id: String { (product ?? "product") + (k ?? "k") + (v ?? "v") }
    }
    
}

extension URLSession {
/**
Retrieves all products for a specific key and/or value.
     
- parameters:
- product: the barcode of the product
- k: the key of the tag
- v : the value of the tag
     
- returns:
    A completion block with a Result enum (success or failure). The associated value for success is a **FSNM.Product** struct and for the failure an Error. The **FSNM.Product** struct has the variables: **product** (String), the barcode of the product; **k**(String) the key of the tag; **v** (String) the value of the tag;
*/
    func FSNMproducts(with key: String?, and value: String?, completion: @escaping (_ result: Result<[FSNM.Product], FSNMError> ) -> Void) {
        let request = HTTPRequest(api: .products, for: nil, with: key, and: value, by: nil, having: nil)
        fetchFSNMArray(request: request, response: FSNM.Product.self) { (result) in
            completion(result)
            return
        }
    }

}
