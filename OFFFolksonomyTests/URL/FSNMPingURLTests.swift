//
//  FSNMURLPingTests.swift
//  OFFFolksonomy
//
//  Created by aleene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPingURLTests: XCTestCase {

    // Ping API tests
    
    func testPingFood() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/ping"
        let url = HTTPRequest(api: .ping).url!
        XCTAssertEqual(url.absoluteString, result)
    }
    
    func testPingPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/ping"
        let url = HTTPRequest(for: .petFood, for: .ping).url!
        XCTAssertEqual(url.description, result)
    }

    func testPingBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/ping"
        let url = HTTPRequest(for: .beauty, for: .ping).url!
        XCTAssertEqual(url.description, result)
    }

    func testPingProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/ping"
        let url = HTTPRequest(for: .product, for: .ping).url!
        XCTAssertEqual(url.description, result)
    }

}
