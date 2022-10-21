//
//  FSNMPingTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPingTest: XCTestCase {

    var offAPI: OFFAPI!
    let apiURL = URL.FSNMPingURL()

    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        offAPI = OFFAPI(urlSession: URLSession.init(configuration: configuration))
        
        expectation = expectation(description: "Expectation")
    }


    func testSuccessfullDecoding() throws {
        let ping = FSNMAPI.Ping(ping: "pong")
        let data = try? JSONEncoder().encode(ping)

        OFFAPI.decode(data: data, type:FSNMAPI.Ping.self) { (result) in
            switch result {
            case .success(let decodedPing):
                XCTAssertEqual(ping.ping, decodedPing.ping!)
            case .failure(let error):
                if let error = error as? APIResponseError {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Error: \(error)")
                } else {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Incorrect error received.")
                }
            }
        }
    }
    
    func testUnsuccesfulDecoding() throws {
        let ping = "pong"
        let jsonString = ["pong": "\(ping)"]
        let data = try? JSONEncoder().encode(jsonString)

        OFFAPI.decode(data: data, type:FSNMAPI.Ping.self) { (result) in
            switch result {
            case .success(let decodedPing):
                if let validDecodedPing = decodedPing.ping {
                    XCTAssertEqual(ping, validDecodedPing)
                } else {
                    // If the data can not be decode I get an empty Ping() back
                    self.expectation?.fulfill()
                }
            case .failure(let error):
                if let error = error as? APIResponseError {
                    XCTFail("FSNMPingTest:testUnsuccesfulDecoding:Error: \(error)")
                } else {
                    XCTFail("FSNMPingTest:testUnsuccesfulDecoding:Incorrect error received.")
                }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
