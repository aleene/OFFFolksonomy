//
//  FSNMDeleteURLTTests.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 06/11/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMDeleteURLTests: XCTestCase {

    // Delete URL test
    
    func testDelete() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product/07951125/test?version=1"
        let tag = FSNM.Tag(product: "07951125", k: "test", v: nil, owner: nil, version: 1, editor: nil, last_edit: nil, comment: nil)
        let url = HTTPRequest(api: .delete, for: tag, having: "").url!
        XCTAssertEqual(url.description, result)
    }

}
