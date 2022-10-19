//
//  FSNMURLPingTests.swift
//  OFFFolksonomy
//
//  Created by aleene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMURLPingTests: XCTestCase {

    // Ping API tests
    
    func testPingFood() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/ping"
        let url = URL.folksonomyPing(with: .food)
        XCTAssertEqual(url.description, result)
    }
    
    func testPingPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/ping"
        let url = URL.folksonomyPing(with: .petFood)
        XCTAssertEqual(url.description, result)
    }

    func testPingBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/ping"
        let url = URL.folksonomyPing(with: .beauty)
        XCTAssertEqual(url.description, result)
    }

    func testPingProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/ping"
        let url = URL.folksonomyPing(with: .product)
        XCTAssertEqual(url.description, result)
    }


}
