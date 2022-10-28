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
    public struct ProductTagVersions: Decodable, Identifiable {
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

/// Function to be used for fetching the product tag versions
    func fetchProductTagVersions(for barcode: OFFBarcode, with key: String, completion: @escaping (_ postResult: (Result<[FSNM.ProductTagVersions], Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        let request = HTTPRequest(api: .productTagVersions, for: barcode.barcode, with: key, and: nil, by: nil, having: nil)
        fetchFSNMArray(request: request, response: FSNM.ProductTagVersions.self) { (result) in
            completion(result)
            return
        }
    }
    
}
