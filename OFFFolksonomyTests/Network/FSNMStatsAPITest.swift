//
//  FSNMPingStatsTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMStatsAPITest: XCTestCase {

    var fsnmSession: URLSession!
    var expectation: XCTestExpectation!
    let key = "ingredients:garlic"
    let apiURL = HTTPRequest(api: .productsStats, for: nil, with: "ingredients:garlic", and: nil, by: nil, having: nil).url!


    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fsnmSession = URLSession(configuration: configuration)
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
        let productStats0 = FSNM.ProductStats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNM.ProductStats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        let array = [productStats0, productsStats1]
   
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
        fsnmSession.fetchStats(with: key) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(_):
                        self.expectation?.fulfill()
                    case .failure(let error):
                        XCTFail("FSNMKeysAPITest:testSuccessfulResponse:Error was not expected: \(error)")
                    }
                } else {
                    XCTFail("FSNMKeysAPITest:testSuccessfulResponse: Wrong response")
                }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
