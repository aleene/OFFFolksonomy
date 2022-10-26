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

extension OFFAPI {
    /// Function to be used for fetching the product tag versions
    func fetchProductTagVersions(for barcode: OFFBarcode, with key: String, completion: @escaping (_ postResult: (Result<[FSNM.ProductTagVersions], Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        fetchArray(url: URL.FSNMProductTagVersionsURL(with: barcode, and: key), response: FSNM.ProductTagVersions.self) { (result) in
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

    /**
    Creates the API URL for the fetching of versions of a product.
    - Parameters:
        - barcode: the barcode of the product
        - productType: the product type of the product
    - Example:
     https://api.folksonomy.openfoodfacts.org/product/3760091720116/evolutions/versions?owner=aleene
    */
    private static func FSNMProductTagVersionsURL(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {
                            
            var url = folksonomyBase(for: productType)
            url += Folksonomy.Product
            url += Divider.Slash
            url += barcode.barcode
            url += Divider.Slash
            url += key
            url += Divider.Slash
            url += Folksonomy.Versions

            if let valid = owner {
                url += Divider.QuestionMark
                url += Folksonomy.Owner
                url += Divider.Equal
                url += valid
            }
            assert(URL(string: url) != nil, "URL:folksonomyTagVersions: url is nil")
            return URL(string: url)!
        }

}
