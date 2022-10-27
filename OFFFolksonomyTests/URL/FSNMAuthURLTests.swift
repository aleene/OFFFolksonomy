//
//  FSNMAuthURLTests.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 24/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMAuthURLTests: XCTestCase {

    // Auth URL test
    
    func testAuth() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/auth"
        let url = HTTPRequest(api: .auth).url!
        XCTAssertEqual(url.description, result)
    }

}
