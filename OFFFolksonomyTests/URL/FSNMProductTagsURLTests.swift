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
        let url = HTTPRequest(api: .tags, for: barcodeToTest, with: nil, and: nil, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest  + "?owner=" + owner
        let url = HTTPRequest(api: .tags, for: barcodeToTest, with: nil, and: nil, by: owner, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

}
