//
//  OFFBarcopde.swift
//  OFFFolksonomy
//
//  Created by aleene 13/10/2022
//

import Foundation

enum OFFBarcode {
    case ean13(String)
    case ean8(String)
    case upc12(String)
    case other(String)
            
    init(barcode: String) {
        switch barcode.count {
        case 8:
            self = .upc12(barcode)
        case 12:
            self = .ean8(barcode)
        case 13:
            self = .ean13(barcode)
        default:
            self = .other(barcode)
        }
    }

    /// The barcode string for a specific barcode length
    var string: String {
        switch self {
        case .ean13(let s):
            return s
        case .ean8(let s):
            return s
        case .upc12(let s):
            return s
        case .other(let s):
            return s
        }
    }

}
