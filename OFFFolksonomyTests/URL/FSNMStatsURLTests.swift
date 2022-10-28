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
    let token = "token"

    func testProductStats() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats"
        let url = HTTPRequest(api: .productsStats).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?owner=" + owner
        let url = HTTPRequest(api: .productsStats, for: nil, with: nil, and: nil, by: owner, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsKey() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?k=" + key
        let url = HTTPRequest(api: .productsStats, for: nil, with: key, and: nil, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?v=" + value
        let url = HTTPRequest(api: .productsStats, for: nil, with: nil, and: value, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    // Try various combinations
    
    func testProductStatsKeyAndValue() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?k=" + key + "&v=" + value
        let url = HTTPRequest(api: .productsStats, for: nil, with: key, and: value, by: nil, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

    func testProductStatsValueAndOwner() throws {
        let result = "https://api.folksonomy.openfoodfacts.org/products/stats?v=" + value + "&owner=" + owner
        let url = HTTPRequest(api: .productsStats, for: nil, with: nil, and: value, by: owner, having: nil).url!
        XCTAssertEqual(url.description, result)
    }

}
