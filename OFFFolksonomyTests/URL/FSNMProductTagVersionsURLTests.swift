//
//  FSNMURLTagVersions.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for: func folksonomyTagVersions(for productType: OFFProductType, with barcode: OFFBarcode, and key: String, by owner: String?) -> URL {

class FSNMProductTagVersionsURLTests: XCTestCase {

    let barcodeToTest = "3760091720115"
    let keyToTest = "keytotest"
    
    func testProduct() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/" + barcodeToTest + "/" + keyToTest + "/versions"
        let url = HTTPRequest(api: .productTagVersions, for: barcodeToTest, with: keyToTest, and: nil, by: nil, having: nil).url!

        XCTAssertEqual(url.description, result)
    }
}
