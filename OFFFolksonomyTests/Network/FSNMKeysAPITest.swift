//
//  FSNMKeysAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMKeysAPITest: XCTestCase {

    var offAPI: OFFAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL.FSNMKeysURL()

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        offAPI = OFFAPI(urlSession: URLSession.init(configuration: configuration))
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
        let key0 = FSNMAPI.Keys(k: "data_quality:robotoff_issue", count: 59, values: 1)
        let key1 = FSNMAPI.Keys(k: "data_quality:robotoff_issue:product_version", count: 59, values: 43)
        let array = [key0, key1]
        let data = try? JSONEncoder().encode(array)

        MockURLProtocol.requestHandler = { request in
            guard let url = request.url,
                  url == self.apiURL else {
            throw APIResponseError.request
        }
        
        let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (response, data)
      }
      
      // Call API.
        FSNMAPI().fetchKeys() { (result) in
            
            switch result {
            case .success(_):
                self.expectation?.fulfill()
            case .failure(let error):
                XCTFail("FSNMKeysAPITest:testSuccessfulResponse:Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
