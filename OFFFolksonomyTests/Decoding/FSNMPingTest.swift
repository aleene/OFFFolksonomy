//
//  FSNMPingTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPingTest: XCTestCase {

    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfullDecoding() throws {
        let ping = FSNM.Ping(ping: "pong")
        if let data = try? JSONEncoder().encode(ping) {
            Decoding.decode(data: data, type:FSNM.Ping.self) { (result) in
                switch result {
                case .success(let decodedPing):
                    XCTAssertEqual(ping.ping, decodedPing.ping!)
                    self.expectation?.fulfill()
                case .failure(let error):
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Error: \(error)")
                }
            }
        } else {
            XCTFail("FSNMPingTest:testSuccessfullDecoding: No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUnsuccesfulDecoding() throws {
        let ping = "pong"
        do {
            let data = try JSONEncoder().encode(ping)
            Decoding.decode(data: data, type:FSNM.Ping.self) { (result) in
                switch result {
                case .success(let decodedPing):
                    XCTAssert(ping != decodedPing.ping)
                case .failure(_):
                    self.expectation?.fulfill()
                }
            }
        } catch {
            XCTFail("FSNMPingTest:testUnsuccesfulDecoding:No valid data.")
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
