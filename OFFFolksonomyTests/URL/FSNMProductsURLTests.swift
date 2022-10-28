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

// no key, value or owner
    
    func testProducts() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products"
        let url = HTTPRequest(api: .products, for: nil, with: nil, and: nil, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductsOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?owner=" + owner
        let url = HTTPRequest(api: .products, for: nil, with: nil, and: nil, by: owner, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductsKey() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?k=" + key
        let url = HTTPRequest(api: .products, for: nil, with: key, and: nil, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductsValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?v=" + value
        let url = HTTPRequest(api: .products, for: nil, with: nil, and: value, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

        // Try various combinations
        
    func testProductsKeyAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?k=" + key + "&v=" + value
        let url = HTTPRequest(api: .products, for: nil, with: key, and: value, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductsOwnerAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products?v=" + value + "&owner=" + owner
        let url = HTTPRequest(api: .products, for: nil, with: nil, and: value, by: owner, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

}
