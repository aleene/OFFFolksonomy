//
//  FSNMPutURLTests.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 06/11/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPutURLTests: XCTestCase {

    // Put URL test
/*
     curl -X 'PUT' \
       'https://api.folksonomy.openfoodfacts.org/product' \
       -H 'accept: application/json' \
       -H 'Content-Type: application/json' \
       -d '{
       "product": "string",
       "k": "string",
       "v": "string",
       "owner": "",
       "version": 1,
       "editor": "string",
       "last_edit": "2022-11-06T14:04:01.167Z",
       "comment": ""
     }'

*/
    func testPut() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/product"
        let tag = FSNM.ProductTags(product: "07951125", k: "test2", v: nil, owner: nil, version: 1, editor: nil, last_edit: nil, comment: nil)
        let url = HTTPRequest(api: .put, for: tag, having: "").url!
        XCTAssertEqual(url.description, result)
    }

}
