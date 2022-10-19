//
//  OFFURL.swift
//  OFFFolksonomy
//
//  Created by aleene 13/10/2022.
//

import Foundation

/// Extension for building an OFF URL
extension URL {
    
    /// Basic components used in an OFF URL
    public struct Divider {
        static let Slash = "/"
        static let Dot = "."
        static let Equal = "="
        static let QuestionMark = "?"
        static let Ampersand = "&"
        static let Scheme = "https://"
        static let Domain = "org"
    }
}

/// Extension required for specifics of the folksonomy api
extension URL {
    
    /// Tte url keys used by the foloksonomy api
    private struct Folksonomy {
        static let API = "api.folksonomy"
        static let Product = "product"
        static let Keys = "keys"
        static let Ping = "ping"
        static let Products = "products"
        static let Stats = "stats"
        static let Key = "k"
        static let Owner = "owner"
        static let Value = "v"
        static let Version = "version"
        static let Versions = "versions"
    }
/**
The URL to get a list of products for a specific key and/or
- Parameters:
 - productType: the product type of the product
 - key: the key of the property
 - value: the value of the property
 - owner: the OFF-user that has added the property

- Example:
    */
    static func folksonomyStats(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?) -> URL {
        
        // to keep track whether the first query field has been added to the ur;
        var fieldSet = false
        
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Products
        url += Divider.Slash
        url += Folksonomy.Stats
        
        if let valid = owner {
            url += Divider.QuestionMark
            url += Folksonomy.Owner
            url += Divider.Equal
            url += valid
            fieldSet = true
        }
        if let valid = key {
            url += !fieldSet ? Divider.QuestionMark : ""
            url += fieldSet ? Divider.Ampersand : ""
            url += Folksonomy.Key
            url += Divider.Equal
            url += valid
            fieldSet = true
        }

        if let valid = value {
            url += !fieldSet ? Divider.QuestionMark : ""
            url += fieldSet ? Divider.Ampersand : ""
            url += Folksonomy.Value
            url += Divider.Equal
            url += valid
        }
        assert(URL(string: url) != nil, "URL:folksonomyProductStats: url is nil")
        return URL(string: url)!
    }

    static func folksonomyProducts(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?) -> URL {
        
        // to keep track whether the first query field has been added to the url;
        var fieldSet = false
        
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Products
        
        if let valid = owner {
            url += Divider.QuestionMark
            url += Folksonomy.Owner
            url += Divider.Equal
            url += valid
            fieldSet = true
        }
        if let valid = key {
            url += !fieldSet ? Divider.QuestionMark : ""
            url += fieldSet ? Divider.Ampersand : ""
            url += Folksonomy.Key
            url += Divider.Equal
            url += valid
            fieldSet = true
        }

        if let valid = value {
            url += !fieldSet ? Divider.QuestionMark : ""
            url += fieldSet ? Divider.Ampersand : ""
            url += Folksonomy.Value
            url += Divider.Equal
            url += valid
        }
        assert(URL(string: url) != nil, "URL:folksonomyProductStats: url is nil")
        return URL(string: url)!
    }

/**
Creates the API URL for the fetching of properties of a product.
 - Parameters:
    - barcode: the barcode of the product
    - productType: the product type of the product
- Example:
    https://api.folksonomy.openfoodfacts.org/product/3760091720116
*/
    static func folksonomyTags(for productType: OFFProductType, with barcode: OFFBarcode, by owner: String?) -> URL {
                
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Product
        url += Divider.Slash
        url += barcode.string
        
        if let valid = owner {
            url += Divider.QuestionMark
            url += Folksonomy.Owner
            url += Divider.Equal
            url += valid
        }
        assert(URL(string: url) != nil, "URL:folksonomyProductStats: url is nil")
        return URL(string: url)!
    }
    
/**
Creates the API URL for the fetching of tags of a product.
- Parameters:
    - barcode: the barcode of the product
    - productType: the product type of the product
- Example:
    https://api.folksonomy.openfoodfacts.org/product/3760091720116/evolutions
    */
    static func folksonomyTags(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {
                    
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Product
        url += Divider.Slash
        url += barcode.string
        url += Divider.Slash
        url += key
        
        if let valid = owner {
            url += Divider.QuestionMark
            url += Folksonomy.Owner
            url += Divider.Equal
            url += valid
        }
        assert(URL(string: url) != nil, "URL:folksonomyProduct: url is nil")
        return URL(string: url)!
    }
/**
Creates the API URL for the fetching of versions of a product.
- Parameters:
    - barcode: the barcode of the product
    - productType: the product type of the product
- Example:
 https://api.folksonomy.openfoodfacts.org/product/3760091720116/evolutions/versions?owner=aleene
*/
    static func folksonomyTagVersions(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {
                        
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Product
        url += Divider.Slash
        url += barcode.string
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
/**
Creates the API URL for the fetching of keys registered.
- Parameters:
- productType: the product type of the product
Example:
    https://api.folksonomy.openfoodfacts.org/keys&owner=aleene
        */
    static func folksonomyKeys(for productType: OFFProductType, by owner: String?) -> URL {
                        
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Keys
            
        if let valid = owner {
            url += Divider.QuestionMark
            url += Folksonomy.Owner
            url += Divider.Equal
            url += valid
        }
        assert(URL(string: url) != nil, "URL:folksonomyKeys: url is nil")
        return URL(string: url)!
    }
    
/// URL to check whether the folksonomy server responds
    public static func folksonomyPing(with productType: OFFProductType) -> URL {
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Ping
        assert(URL(string: url) != nil, "URL:folksonomyPing: url is nil")
        return URL(string: url)!
    }
    
    /**
    Creates the API URL for the fetching of tags of a product.
    - Parameters:
        - barcode: the barcode of the product
        - productType: the product type of the product
    - Example:
     https://api.folksonomy.openfoodfacts.org/product/3760091720116/6?owner=aleene
    */
    static func folksonomyDelete(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, version: Int, by owner: String?) -> URL {
                            
        var url = folksonomyBase(for: productType)
        url += Folksonomy.Product
        url += Divider.Slash
        url += barcode.string
        url += Divider.Slash
        url += key
        url += Divider.QuestionMark
        url += Folksonomy.Version
        url += Divider.Equal
        url += "\(version)"
        
        if let valid = owner {
            url += Divider.Ampersand
            url += Folksonomy.Owner
            url += Divider.Equal
            url += valid
        }
        assert(URL(string: url) != nil, "URL:folksonomyTagVersions: url is nil")
        return URL(string: url)!
    }

    private static func folksonomyBase(for productType: OFFProductType) -> String {
        var url = Divider.Scheme
        url += Folksonomy.API
        url += Divider.Dot
        // add the right host
        url += productType.host
        url += Divider.Dot
        url += Divider.Domain
        url += Divider.Slash
        return url
    }

}

/// Extension required for specifics of the different product types of OFF
extension OFFProductType {
    
    /// The host part of an URL for a producttype
    var host: String {
        switch self {
        case .food: return "openfoodfacts"
        case .petFood: return "openpetfoodfacts"
        case .beauty: return "openbeautyfacts"
        case .product: return "openproductfacts"
        }
    }
}
