//
//  FSNMURLTagsForKeyTests.swift
//  OFFFolksonomyTests
//
//  Created by aleene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for: func folksonomyTags(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL

class FSNMURLTagsForKeyTests: XCTestCase {

    let barcodeToTest = "3760091720115"
    let keyToTest = "keytotest"
    let owner = "testmeowner"

    func testProduct() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest
        let url = URL.folksonomyTags(for: .food, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/product/" + barcodeToTest + "/" + keyToTest
        let url = URL.folksonomyTags(for: .beauty, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest
        let url = URL.folksonomyTags(for: .petFood, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/product/" + barcodeToTest + "/" + keyToTest
        let url = URL.folksonomyTags(for: .product, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest  + "/" + keyToTest + "?owner=" + owner
        let url = URL.folksonomyTags(for: .food, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: owner)
        XCTAssertEqual(url.description, result)
    }

}
