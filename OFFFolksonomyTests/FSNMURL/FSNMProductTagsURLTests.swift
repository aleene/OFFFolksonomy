//
//  FSNMURLTagsForKeyTests.swift
//  OFFFolksonomyTests
//
//  Created by aleene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for: func folksonomyTags(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL

class FSNMProductTagsURLTests: XCTestCase {

    let barcodeToTest = "3760091720115"
    let key = "evolutions"
    let owner = "testmeowner"

    func testProduct() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest
        let url = URL.FSNMProductTagsURL(for: .food, with: OFFBarcode(barcode: barcodeToTest), by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/product/" + barcodeToTest
        let url = URL.FSNMProductTagsURL(for: .beauty, with: OFFBarcode(barcode: barcodeToTest), by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/product/" + barcodeToTest
        let url = URL.FSNMProductTagsURL(for: .petFood, with: OFFBarcode(barcode: barcodeToTest), by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/product/" + barcodeToTest
        let url = URL.FSNMProductTagsURL(for: .product, with: OFFBarcode(barcode: barcodeToTest), by: nil)
        XCTAssertEqual(url.description, result)
    }

    func testProductOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest  + "?owner=" + owner
        let url = URL.FSNMProductTagsURL(for: .food, with: OFFBarcode(barcode: barcodeToTest), by: owner)
        XCTAssertEqual(url.description, result)
    }

    func testProductWithKey() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest  + "/" + key
        let url = URL.FSNMProductTagsURL(with: OFFBarcode(barcode: barcodeToTest), and: key)
        XCTAssertEqual(url.description, result)
    }

}
