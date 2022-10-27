//
//  FSNMURLKeys.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for func folksonomyKeys(for productType: OFFProductType, by owner: String?) -> URL {

class FSNMKeysURLTests: XCTestCase {

    let owner = "testmeowner"

    func testProduct() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/keys"
        let url = URL.FSNMKeysURL(for: .food, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/keys"
        let url = URL.FSNMKeysURL(for: .beauty, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/keys"
        let url = URL.FSNMKeysURL(for: .petFood, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/keys"
        let url = URL.FSNMKeysURL(for: .product, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/keys?owner=" + owner
        let url = URL.FSNMKeysURL(for: .food, by: owner)
        XCTAssertEqual(url.description, result)
    }

}
