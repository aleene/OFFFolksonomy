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
        let url = HTTPRequest(api: .keys).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/keys?owner=" + owner
        let url = HTTPRequest(api: .keys, for: nil, with: nil, and: nil, by: owner, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

}
