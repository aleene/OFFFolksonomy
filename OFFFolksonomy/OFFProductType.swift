//
//  ProductType.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import Foundation

/** An enumerator type describing all possible OpenFoodFacts sites that exist
 
Values:
 - food - for food products
    - petFood - for petfood products
    - beauty - for beauty products
    - product - for any other product (not food, petfood, beauty)
*/
enum OFFProductType: String {
    case food
    case petFood
    case beauty
    case product
    
    /// A a human readable description of the current value for Product Type.
    /// - Returns:  String
    func description() -> String {
        switch self {
        case .food:
            return "Food product"
        case .petFood:
            return "Petfood product"
        case .beauty:
            return "Beauty product"
        case .product:
            return "General product"
        }
    }
}
