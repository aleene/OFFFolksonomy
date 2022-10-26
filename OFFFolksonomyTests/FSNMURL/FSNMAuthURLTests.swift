//
//  FSNMAuthURLTests.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 24/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMAuthURLTests: XCTestCase {

    // Ping API tests
    
    func testAuth() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/auth"
        let url = URL.FSNMAuthURL()
        XCTAssertEqual(url.description, result)
    }

}
