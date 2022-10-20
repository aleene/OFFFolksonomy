//
//  FSNMPingTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPingTest: XCTestCase {

    func decodingTest() {
        let ping = "pong"
        let jsonString = """
                         {
                            "ping": "\(ping)",
                         }
                         """
        let data = jsonString.data(using: .utf8)
        
        OFF.decode(data: data, type:FSNMAPI.Ping.self) { (result) in
            switch result {
            case .success(let decodedPing):
                XCTAssertEqual(ping, decodedPing.ping!)
            case .failure(let error):
                if let error = error as? APIResponseError {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Error: \(error)")
                } else {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Incorrect error received.")
                }
            }
        }
    }
}
