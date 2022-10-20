//
//  OFFURLExtension.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
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
