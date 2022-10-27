//
//  FSNMUrlProductsTests.swift
//  OFFFolksonomyTests
//
//  Created by aleene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for func folksonomyProducts(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?)

class FSNMProductsURLTests: XCTestCase {

    let value = "testme"
    let owner = "testalso"
    let key = "testme"

// Test URL.FSNMProductsURL(with: key)
    
    func testProductsWith() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?k=" + key
        let url = URL.FSNMProductsURL(with: key)
        XCTAssertEqual(url.description, result)
    }


// no key, value or owner
    
    func testProducts() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products"
        let url = URL.FSNMProductsURL(for: .food, with: nil, and: nil, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductsBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/products"
        let url = URL.FSNMProductsURL(for: .beauty, with: nil, and: nil, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductsPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/products"
        let url = URL.FSNMProductsURL(for: .petFood, with: nil, and: nil, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductsProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/products"
        let url = URL.FSNMProductsURL(for: .product, with: nil, and: nil, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductsOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?owner=" + owner
        let url = URL.FSNMProductsURL(for: .food, with: nil, and: nil, by: owner)
        XCTAssertEqual(url.description, result)
    }

    func testProductsKey() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?k=" + key
        let url = URL.FSNMProductsURL(for: .food, with: key, and: nil, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductsValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?v=" + value
        let url = URL.FSNMProductsURL(for: .food, with: nil, and: value, by: nil)
        XCTAssertEqual(url.description, result)
    }

        // Try various combinations
        
    func testProductsKeyAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?k=" + key + "&v=" + value
        let url = URL.FSNMProductsURL(for: .food, with: key, and: value, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductsOwnerAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?owner=" + owner + "&v=" + value
        let url = URL.FSNMProductsURL(for: .food, with: nil, and: value, by: owner)
        XCTAssertEqual(url.description, result)
    }

}
