//
//  FSNMPingAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 18/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMPingAPITest: XCTestCase {

    var offSession: URLSession!
    var expectation: XCTestExpectation!
    // I do not need to test this again
    let request = HTTPRequest(api: .ping)


    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        offSession = URLSession(configuration: configuration)
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
      let ping = "pong"
      let jsonString = """
                       {
                          "ping": "\(ping)",
                       }
                       """
      let data = jsonString.data(using: .utf8)
      
      MockURLProtocol.requestHandler = { request in
        guard let url = request.url,
              url == request.url else {
            throw FSNMError.request
        }
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (response, data)
      }
      
      // Call API.
        offSession.FSNMping { (result) in
            
            switch result {
            case .success(let post):
                let pong = post.ping!.contains(ping) ? ping : "there is no pong"
                XCTAssertEqual(pong, ping, "FSNMPingAPITest:testSuccessfulResponse:Incorrect body.")
            case .failure(let error):
                XCTFail("FSNMPingAPITest:testSuccessfulResponse:Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
