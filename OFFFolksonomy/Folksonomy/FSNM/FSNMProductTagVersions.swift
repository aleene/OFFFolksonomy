//
//  FSNMProductTagVersions.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import Foundation

//
//  Extensions for the Product Tag Versions API
//
extension FSNM {
        
    /// the datastructure retreived for a succesful reponse 200
    public struct TagVersion: Decodable, Identifiable {
        public var product: String?
        public var k: String?
        public var v: String?
        public var version: Int?
        public var editor: String?
        public var last_edit: String?
        public var comment: String?
        
        public var id: String { last_edit! }
    }
    
}

extension URLSession {

/**
Retrieves a list of versions for a product and a key.
 
- Parameters:
 - product: the barcode of the product
 - k: the key of the tag
 - value : the value of the tag
 - 'version: the version of the tag
 - editor: the editor of the tag
 - last_edit: the last edit date of the tag
 - comment: a comment associated with the version
 
- returns:
    A completion block with a Result enum (success or failure). The associated value for success is a **FSNM.TagVersion** struct and for the failure an Error. The **FSNM.TagVersion** struct has the variables: **product** (String), the barcode of the product; **k**(String) the key of the tag; **v** (String) the value of the tag; **version** (Int) the version number of the tag; **editor** (String) the editor of this version; **last_edit** (String) the edit date of this version; **comment** (String) the associated comment for this version.
*/
    func FSNMtagVersions(for barcode: OFFBarcode, with key: String, completion: @escaping (_ postResult: Result<[FSNM.TagVersion], FSNMError> ) -> Void) {
        let request = HTTPRequest(api: .productTagVersions, for: barcode.barcode, with: key, and: nil, by: nil, having: nil)
        
        fetchFSNMArray(request: request, response: FSNM.TagVersion.self) { (result) in
            completion(result)
            return
        }
    }
    
}
