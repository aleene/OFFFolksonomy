//
//  OFF.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import Foundation

public struct OFFURL {
    
    public struct Component {
        public struct Divider {
            static let Slash = "/"
            static let Dot = "."
            static let Equal = "="
            static let QuestionMark = "?"
            static let Ampersand = "&"
        }
        
        static let Scheme = "https://"
        static let Domain = "org"
    }
    
}


extension OFFURL {
    
    private struct Folksonomy {
        static let API = "api.folksonomy"
        static let GetProduct = "product"
    }
/**
    
- Example:
    https://api.folksonomy.openfoodfacts.org/product/3760091720116

*/
    static func folksonomyFetch(for barcode: OFFBarcode, with productType: OFFProductType) -> URL {
        var url = Component.Scheme
        url += Folksonomy.API
        url += Component.Divider.Dot
        // add the right host
        url += productType.host
        url += Component.Divider.Dot
        url += Component.Domain
        url += Component.Divider.Slash
        url += Folksonomy.GetProduct
        url += Component.Divider.Slash
        url += barcode.string
        assert(URL(string: url) != nil, "OFF:folksonomyFetch: url is nil")
        return URL(string: url)!
    }
}

extension OFFProductType {
    /// The host part of the web-adress
    var host: String {
        switch self {
        case .food: return "openfoodfacts"
        case .petFood: return "openpetfoodfacts"
        case .beauty: return "openbeautyfacts"
        case .product: return "openproductfacts"
        }
    }
}
