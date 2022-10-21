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
extension FSNMAPI {
        
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

extension OFFAPI {
    /// Function to be used for fetching the product tag versions
    func fetchProductTagVersions(for barcode: OFFBarcode, with key: String, completion: @escaping (_ postResult: (Result<[FSNMAPI.ProductTagVersions], Error>?, Result<FSNMAPI.ValidationError, Error>?) ) -> Void) {
        fetchArray(url: URL.FSNMProductTagVersionsURL(with: barcode, and: key), response: FSNMAPI.ProductTagVersions.self) { (result) in
            completion(result)
            return
        }
    }
    
}

extension URL {

/// Convienience URL to get versions of a key of a product
    public static func FSNMProductTagVersionsURL(with barcode: OFFBarcode, and key: String) -> URL {
        return FSNMProductTagVersionsURL(for: .food, with: barcode, and: key, by: nil)
    }

/// Convienience URL to get versions of a key of a product for an owner
    public static func FSNMProductTagVersionsURL(with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {
        return FSNMProductTagVersionsURL(for: .food, with: barcode, and: key, by: owner)
    }

}
