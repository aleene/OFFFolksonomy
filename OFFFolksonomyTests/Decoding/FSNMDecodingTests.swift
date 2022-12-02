//
//  FSNMPingTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMDecodingTests: XCTestCase {

    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = expectation(description: "Expectation")
    }
    // A test where the input corrersponds to the output (key, value and structure)
    func testDecodingCorrect() throws {
        let ping = FSNM.Ping(ping: "pong")
        if let data = try? JSONEncoder().encode(ping) {
            Decoding.decode(data: data, type:FSNM.Ping.self) { (result) in
                switch result {
                case .success(let decodedPing):
                    XCTAssertEqual(ping.ping, decodedPing.ping!)
                    self.expectation?.fulfill()
                case .failure(let error):
                    XCTFail("FSNMPingTest:testDecodingCorrect: Error: \(error)")
                }
            }
        } else {
            XCTFail("FSNMPingTest:testDecodingCorrect: No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // test where the input and output json structures are different
    func testDecodingStructureMismatch() throws {
        let ping = "pong"
        do {
            let data = try JSONEncoder().encode(ping)
            Decoding.decode(data: data, type:FSNM.Ping.self) { (result) in
                switch result {
                case .success(let decodedPing):
                    XCTAssert(ping != decodedPing.ping)
                case .failure(let error):
                    switch error {
                    case .valueNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingStructureMismatch:valueNotFound")
                    case .typeMismatch(_, _):
                        self.expectation?.fulfill()
                    case .keyNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingStructureMismatch:keyNotFound")
                    case .dataCorrupted(_):
                        XCTFail("RBTFDecodingTests:testDecodingStructureMismatch:dataCorrupted")
                    @unknown default:
                        XCTFail("RBTFDecodingTests:testDecodingStructureMismatch:Error")
                    }
                }
            }
        } catch {
            XCTFail("FSNMPingTest:testUnsuccesfulDecoding:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // test where the values are different
    func testDecodingValuesDifferent() throws {
        let jsonString = """
                             {
                                "k": "string",
                                "count": 6,
                                "values": 8
                             }
                             """
        let key = FSNM.Key(k: "string", count: 6, values: 4)
        if let data = jsonString.data(using: .utf8) {
            Decoding.decode(data: data, type:FSNM.Key.self) { (result) in
                switch result {
                case .success(let decodedKey):
                    if key == decodedKey {
                        XCTFail("RBTFDecodingTests:testDecodingValuesDifferent:values the same")
                    } else {
                        self.expectation?.fulfill()
                    }
                case .failure(let error):
                    switch error {
                    case .valueNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingValuesDifferent:valueNotFound")
                    case .typeMismatch(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingValuesDifferent:typeMismatch")
                    case .keyNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingValuesDifferent:keyNotFound")
                    case .dataCorrupted(_):
                        XCTFail("RBTFDecodingTests:testDecodingValuesDifferent:dataCorrupted")
                    @unknown default:
                        XCTFail("RBTFDecodingTests:testDecodingValuesDifferent:Error")
                    }
                }
            }
        } else {
            XCTFail("FSNMPingTest:testUnsuccesfulDecoding:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // test where the values are different: is not detected as an issue
    // the decoder just does not take the extra key into account
    // how can I get this to fail? The d
    func testDecodingExtraKey() throws {
        let jsonString = """
                             {
                                "k": "string",
                                "count": 6,
                                "values": 4,
                                "extra": "will not be taken into account"
                             }
                             """
        let key = FSNM.Key(k: "string", count: 6, values: 4)
        if let data = jsonString.data(using: .utf8) {
            Decoding.decode(data: data, type: FSNM.Key.self) { (result) in
                switch result {
                case .success(let decodedKey):
                    if key == decodedKey {
                        self.expectation?.fulfill()

                    } else {
                        XCTFail("RBTFDecodingTests:testDecodingExtraKey:input/output are the same")
                    }
                case .failure(let error):
                    switch error {
                    case .valueNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingExtraKey:valueNotFound")
                    case .typeMismatch(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingExtraKey:typeMismatch")
                    case .keyNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingExtraKey:keyNotFound")
                    case .dataCorrupted(_):
                        XCTFail("RBTFDecodingTests:testDecodingExtraKey:dataCorrupted")
                    @unknown default:
                        XCTFail("RBTFDecodingTests:testDecodingExtraKey:Error")
                    }
                }
            }
        } else {
            XCTFail("FSNMPingTest:testUnsuccesfulDecoding:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // test where a key/value combination is missing
    func testDecodingMissingKey() throws {
        let jsonString = """
                             {
                                "count": 6,
                                "values": 4,
                             }
                             """
        let key = FSNM.Key(k: "string", count: 6, values: 4)
        if let data = jsonString.data(using: .utf8) {
            Decoding.decode(data: data, type: FSNM.Key.self) { (result) in
                switch result {
                case .success(let decodedKey):
                    if key == decodedKey {
                        XCTFail("RBTFDecodingTests:testDecodingMissingKey:input/output are the same")
                    } else {
                        self.expectation?.fulfill()
                    }
                case .failure(let error):
                    switch error {
                    case .valueNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingMissingKey:valueNotFound")
                    case .typeMismatch(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingMissingKey:typeMismatch")
                    case .keyNotFound(_, _):
                        XCTFail("RBTFDecodingTests:testDecodingMissingKey:keyNotFound")
                    case .dataCorrupted(_):
                        XCTFail("RBTFDecodingTests:testDecodingMissingKey:dataCorrupted")
                    @unknown default:
                        XCTFail("RBTFDecodingTests:testDecodingMissingKey:Error")
                    }
                }
            }
        } else {
            XCTFail("RBTFDecodingTests:testDecodingMissingKey:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
