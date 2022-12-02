//
//  FSNMStatsTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMDecodingArrayTest: XCTestCase {

    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulDecoding() throws {
        let productStats0 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        let array = [productStats0, productsStats1]
   
        do {
            let data = try JSONEncoder().encode(array)
                
            Decoding.decodeArray(data: data, type:FSNM.Stats.self) { (result) in
                switch result {
                case .success(let decodedProductStats):
                    if array == decodedProductStats {
                        self.expectation?.fulfill()
                    } else {
                        XCTFail("FSNMDecodingArrayTest:successfulDecodingTest:Not equal.")
                    }
                case .failure(let error):
                        XCTFail("FSNMDecodingArrayTest:successfulDecodingTest:Error: \(error)")
                }
            }
        } catch {
            XCTFail("FSNMDecodingArrayTest:testDecodeOneQuestions:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testDecodingArrayLenghtsDifferent() throws {
           
        var productStats0 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNM.Stats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        let array = [productStats0, productsStats1]
        let array2 = [productStats0]
        do {
            let data = try JSONEncoder().encode(array)
            Decoding.decodeArray(data: data, type:FSNM.Stats.self) { (result) in
                switch result {
                case .success(let decodedProductStats):
                    if array2 == decodedProductStats {
                        XCTFail("FSNMDecodingArrayTest:successfulDecodingTest: equal length array.")
                    } else {
                        self.expectation?.fulfill()
                    }
                case .failure(let error):
                    switch error {
                    case .valueNotFound(_, _):
                        XCTFail("FSNMDecodingArrayTest:testDecodeTypeMismatch:valueNotFound:")
                    case .typeMismatch(_, _):
                        XCTFail("FSNMDecodingArrayTest:testDecodeTypeMismatch:typeMismatch:")
                    case .keyNotFound(_, _):
                        XCTFail("FSNMDecodingArrayTest:testDecodeTypeMismatch:keyNotFound:")
                    case .dataCorrupted(_):
                        XCTFail("FSNMDecodingArrayTest:testDecodeTypeMismatch:dataCorrupted:")
                    @unknown default:
                        XCTFail("FSNMDecodingArrayTest:testDecodeTypeMismatch:Error:")
                    }
                }
            }
        } catch {
            XCTFail("FSNMStatsTest:testDecodeOneQuestions:No valid data.")
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Provide Ints instead of String
    func testDecodingArrayTypeMismatch() throws {
           
        // Setup an arbitrary array as check
        let dict1 = ["product8": 6, "keys": 1, "last_edit": 2, "editors": 1]
        let dict2 = ["product8": 6, "keys": 1, "last_edit": 2, "editors": 1]
        let array = [dict1, dict2]
        
        do {
            let data = try JSONEncoder().encode(array)
        
            Decoding.decodeArray(data: data, type:FSNM.Stats.self) { (result) in
            switch result {
            case .success(_):
                XCTFail("FSNMPingTest:testWrongJsonDecoding:No success expected.")
            case .failure(let error):
                switch error {
                case .valueNotFound(_, _):
                    XCTFail("FSNMStatsTest:testDecodeTypeMismatch:valueNotFound:")
                case .typeMismatch(_, _):
                    self.expectation?.fulfill()
                case .keyNotFound(_, _):
                    XCTFail("FSNMStatsTest:testDecodeTypeMismatch:keyNotFound:")
                case .dataCorrupted(_):
                    XCTFail("FSNMStatsTest:testDecodeTypeMismatch:dataCorrupted:")
                @unknown default:
                    XCTFail("FSNMStatsTest:testDecodeTypeMismatch:Error:")
                }
            }
            }
        } catch {
            XCTFail("FSNMStatsTest:testDecodeOneQuestions:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
