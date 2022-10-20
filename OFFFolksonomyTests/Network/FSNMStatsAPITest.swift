//
//  FSNMPingStatsTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMStatsAPITest: XCTestCase {

    var fsnmAPI: FSNMAPI!
    var expectation: XCTestExpectation!
    let key = "ingredients:garlic"
    let apiURL = URL.FSNMStatsURL(with: "ingredients:garlic")


    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fsnmAPI = FSNMAPI(urlSession: URLSession.init(configuration: configuration))
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
        let product1barcode = "0011110805805"
        let jsonString = """
                       [
                            {
                                "product": "\(product1barcode)",
                                "keys": 1,
                                "last_edit": "2022-10-11T18:01:21.65963",
                                "editors": 1
                            },
                            {
                                "product": "0011110814395",
                                "keys": 1,
                                "last_edit": "2022-10-11T18:01:50.208173",
                                "editors": 1
                            }
                       ]
                       """
        let data = jsonString.data(using: .utf8)
      
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url,
                  url == self.apiURL else {
            throw APIResponseError.request
        }
        
        let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (response, data)
      }
      
      // Call API.
        fsnmAPI.fetchStats(with: key) { (result) in
            
            switch result {
            case .success(let products):
                XCTAssertEqual(products[0].product, product1barcode, "FSNMStatsAPITest:testSuccessfulResponse:Incorrect body.")
            case .failure(let error):
                XCTFail("FSNMStatsAPITest:testSuccessfulResponse:Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testParsingFailure() {
        // Prepare mock json response.
        let product1barcode = "0011110805805"
        let jsonString = """
                         [
                              {
                                  "product": "\(product1barcode)",
                                  "keys": 1,
                                  "last_edit": "2022-10-11T18:01:21.65963",
                                  "editors": 1
                              },
                              {
                                  "product": "0011110814395",
                                  "wrongCodeHere": 1,
                                  "last_edit": "2022-10-11T18:01:50.208173",
                                  "editors": 1
                              }
                         ]
                         """
        let data = jsonString.data(using: .utf8)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API
        fsnmAPI.fetchPing() { (result) in
            switch result {
            case .success(_):
                XCTFail("FSNMStatsAPITest:testParsingFailure:Success response was not expected.")
            case .failure(let error):
                guard let error = error as? APIResponseError else {
                    XCTFail("FSNMStatsAPITest:testParsingFailure:Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertEqual(error, APIResponseError.parsing, "FSNMStatsAPITest:testParsingFailure:Parsing error was expected.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
