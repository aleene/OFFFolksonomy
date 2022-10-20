//
//  FSNMURLStatsTests.swift
//  OFFFolksonomyTests
//
//  Created by aleene on 17/10/2022.
//

import XCTest
@testable import OFFFolksonomy

// Tests for func folksonomyStats(for productType: OFFProductType, with key: String?, and value: String?, by owner: String?) -> URL
class FSNMStatsURLTests: XCTestCase {
    
    let value = "testme"
    let owner = "testalso"
    let key = "testme"

    func testProductStats() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats"
        let url = URL.FSNMStatsURL(for: .food, with: nil, and: nil, by: nil )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsBeauty() throws {
        let result = "https://api.folksonomy.openbeautyfacts.org/products/stats"
        let url = URL.FSNMStatsURL(for: .beauty, with: nil, and: nil, by: nil )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsPetFood() throws {
        let result = "https://api.folksonomy.openpetfoodfacts.org/products/stats"
        let url = URL.FSNMStatsURL(for: .petFood, with: nil, and: nil, by: nil )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsProduct() throws {
        let result = "https://api.folksonomy.openproductfacts.org/products/stats"
        let url = URL.FSNMStatsURL(for: .product, with: nil, and: nil, by: nil )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?owner=" + owner
        let url = URL.FSNMStatsURL(for: .food, with: nil, and: nil, by: owner )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsKey() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?k=" + key
        let url = URL.FSNMStatsURL(for: .food, with: key, and: nil, by: nil )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?v=" + value
        let url = URL.FSNMStatsURL(for: .food, with: nil, and: value, by: nil )
        XCTAssertEqual(url.description, result)
    }

    // Try various combinations
    
    func testProductStatsKeyAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?k=" + key + "&v=" + value
        let url = URL.FSNMStatsURL(for: .food, with: key, and: value, by: nil )
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsOwnerAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?owner=" + owner + "&v=" + value
        let url = URL.FSNMStatsURL(for: .food, with: nil, and: value, by: owner )
        XCTAssertEqual(url.description, result)
    }

}
