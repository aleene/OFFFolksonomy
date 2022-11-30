//
//  FSNMPingTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPingTest: XCTestCase {

    func testSuccessfullDecoding() throws {
        let ping = FSNM.Ping(ping: "pong")
        let data = try? JSONEncoder().encode(ping)

        OFFAPI.decode(data: data, type:FSNM.Ping.self) { (result) in
            switch result {
            case .success(let decodedPing):
                XCTAssertEqual(ping.ping, decodedPing.ping!)
            case .failure(let error):
                XCTFail("FSNMPingTest:testSuccessfulDecoding:Error: \(error)")
            }
        }
    }
    
    func testUnsuccesfulDecoding() throws {
        let ping = "pong"
        let jsonString = ["pong": "\(ping)"]
        let data = try? JSONEncoder().encode(jsonString)

        OFFAPI.decode(data: data, type:FSNM.Ping.self) { (result) in
            switch result {
            case .success(let decodedPing):
                XCTAssert(ping != decodedPing.ping)
            case .failure(let error):
                XCTFail("FSNMPingTest:testUnsuccesfulDecoding:Error: \(error)")
            }
        }
    }

}
