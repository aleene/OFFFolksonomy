//
//  FSNMKeysAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMKeysAPITest: XCTestCase {

    var fsnmAPI: FSNMAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL.FSNMKeysURL()

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fsnmAPI = FSNMAPI(urlSession: URLSession.init(configuration: configuration))
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
        let k_example = "data_quality:robotoff_issue"
        let jsonString = """
                       [
                         {
                           "k": "data_quality:robotoff_issue",
                           "count": 59,
                           "values": 1
                         },
                         {
                           "k": "data_quality:robotoff_issue:product_version",
                           "count": 59,
                           "values": 43
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
        fsnmAPI.fetchKeys() { (result) in
            
            switch result {
            case .success(let keys):
                XCTAssertEqual(keys[0].k, k_example, "FSNMKeysAPITest:testSuccessfulResponse:Incorrect body.")
            case .failure(let error):
                XCTFail("FSNMKeysAPITest:testSuccessfulResponse:Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testParsingFailure() {
        // Prepare mock json response.
        let jsonString = """
                         [
                           {
                             "lkey": "this is a wrong key",
                             "count": 59,
                             "values": 1
                           },
                           {
                             "k": "data_quality:robotoff_issue:product_version",
                             "count": 59,
                             "values": 43
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
            case .success(let keys):
                print(keys)
                XCTFail("FSNMKeysAPITest:testParsingFailure:Success response was not expected.")
            case .failure(let error):
                guard let error = error as? APIResponseError else {
                    XCTFail("FSNMKeysAPITest:testParsingFailure:Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertEqual(error, APIResponseError.parsing, "FSNMKeysAPITest:testParsingFailure:Parsing error was expected.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
