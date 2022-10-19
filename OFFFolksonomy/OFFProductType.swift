//
//  ProductType.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import Foundation

/**
An enumerator type describing all possible OpenFoodFacts product types that are supported
 
Values:
 - food - for food pzroducts
    - petFood - for petfood products
    - beauty - for beauty products
    - product - for any other product (not food, petfood, beauty)
*/
public enum OFFProductType: String {
    case food
    case petFood
    case beauty
    case product
    
    /// A a human readable description of the current value for Product Type.
    var description: String {
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
