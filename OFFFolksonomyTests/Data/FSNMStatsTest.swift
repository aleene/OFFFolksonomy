//
//  FSNMStatsTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMStatsTest: XCTestCase {

    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulDecoding() throws {
        let productStats0 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        let array = [productStats0, productsStats1]
   
        let data = try? JSONEncoder().encode(array)
                
        OFFAPI.decodeArray(data: data, type:FSNM.Stats.self) { (result) in
            switch result {
            case .success(let decodedProductStats):
                if array == decodedProductStats {
                    self.expectation?.fulfill()
                } else {
                    XCTFail("FSNMPingTest:successfulDecodingTest:Not equal.")
                }
            case .failure(let error):
                    XCTFail("FSNMPingTest:successfulDecodingTest:Error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testValueChangedDecoding() throws {
           
        var productStats0 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        var array = [productStats0, productsStats1]
   
        let data = try? JSONEncoder().encode(array)

        productStats0.product = "changed code"
        array = [productStats0, productsStats1]
        
        OFFAPI.decodeArray(data: data, type:FSNM.Stats.self) { (result) in
            switch result {
            case .success(let decodedProductStats):
                if array == decodedProductStats {
                    XCTFail("FSNMPingTest:successfulDecodingTest:Not equal.")
                } else {
                    self.expectation?.fulfill()
                }
            case .failure(let error):
                    switch error {
                    case .parsing:
                        self.expectation?.fulfill()
                    default:
                        XCTFail("FSNMPingTest:testWrongJsonDecoding:Wrong error received: \(error)")
                    }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testkeysChangedDecoding() throws {
           
        // Setup an arbitrary array as check
        let dict1 = ["product8": 6, "keys": 1, "last_edit": 2, "editors": 1]
        let dict2 = ["product8": 6, "keys": 1, "last_edit": 2, "editors": 1]
        let array = [dict1, dict2]
        let data = try? JSONEncoder().encode(array)
        
        OFFAPI.decodeArray(data: data, type:FSNM.Stats.self) { (result) in
            switch result {
            case .success(_):
                XCTFail("FSNMPingTest:testWrongJsonDecoding:No success expected.")
            case .failure(let error):
                    switch error {
                    case .parsing:
                        self.expectation?.fulfill()
                    default:
                        XCTFail("FSNMPingTest:testWrongJsonDecoding:Wrong error received: \(error)")
                    }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
