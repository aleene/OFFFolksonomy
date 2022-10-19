//
//  FSNMURLDelete.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for folksonomyDelete(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, version: Int, by owner: String?) -> URL

class FSNMURLDelete: XCTestCase {

    let barcodeToTest = "3760091720115"
    let keyToTest = "keytotest"
    let version = 8
    let owner = "testowner"

    func testProduct() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest + "?version=\(version)"
        let url = URL.folksonomyDelete(for: .food, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, version: version, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/product/" + barcodeToTest + "/" + keyToTest + "?version=\(version)"
        let url = URL.folksonomyDelete(for: .beauty, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, version: version, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest + "?version=\(version)"
        let url = URL.folksonomyDelete(for: .petFood, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, version: version, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/product/" + barcodeToTest + "/" + keyToTest + "?version=\(version)"
        let url = URL.folksonomyDelete(for: .product, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, version: version, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest + "?version=\(version)" + "&owner=" + owner
        let url = URL.folksonomyDelete(for: .food, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, version: version, by: owner)
        XCTAssertEqual(url.description, result)
    }

}
