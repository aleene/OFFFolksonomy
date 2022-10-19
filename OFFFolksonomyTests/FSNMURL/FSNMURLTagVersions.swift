//
//  FSNMURLTagVersions.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for: func folksonomyTagVersions(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {

class FSNMURLTagVersions: XCTestCase {

    let barcodeToTest = "3760091720115"
    let keyToTest = "keytotest"
    
    func testProduct() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest + "/versions"
        let url = URL.folksonomyTagVersions(for: .food, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/product/" + barcodeToTest + "/" + keyToTest + "/versions"
        let url = URL.folksonomyTagVersions(for: .beauty, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest + "/versions"
        let url = URL.folksonomyTagVersions(for: .petFood, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/product/" + barcodeToTest + "/" + keyToTest + "/versions"
        let url = URL.folksonomyTagVersions(for: .product, with: OFFBarcode(barcode: barcodeToTest), and: keyToTest, by: nil)
        XCTAssertEqual(url.description, result)
    }

}
