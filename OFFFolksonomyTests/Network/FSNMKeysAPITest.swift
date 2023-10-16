//
//  FSNMKeysAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMKeysAPITest: XCTestCase {

    var fsnmSession: URLSession!
    var expectation: XCTestExpectation!
    let apiURL = HTTPRequest(api: .keys).url!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fsnmSession = URLSession(configuration: configuration)

        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse200() {
        // Prepare mock json response.
        let key0 = FSNM.Key(k: "data_quality:robotoff_issue", count: 59, values: 1)
        let key1 = FSNM.Key(k: "data_quality:robotoff_issue:product_version", count: 59, values: 43)
        let array = [key0, key1]
        let data = try? JSONEncoder().encode(array)

        MockURLProtocol.requestHandler = { request in
                guard let url = request.url,
                  url == self.apiURL else {
                    throw FSNMError.request
            }
        
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
      
        // Call API.
        fsnmSession.FSNMkeys() { (result) in
            DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                       self.expectation?.fulfill()
                    case .failure(let error):
                        XCTFail("FSNMKeysAPITest:testSuccessfulResponse: error was not expected: \(error)")
                   }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSuccessfulResponse422() {
        // Prepare mock json response.
        let valerdet = FSNM.ValidationErrorDetail(loc: ["string"], msg: "msg", type: "type")
        let mes = FSNM.ValidationError(detail: [valerdet])
        let data = try? JSONEncoder().encode(mes)

        MockURLProtocol.requestHandler = { request in
                guard let url = request.url,
                  url == self.apiURL else {
                throw FSNMError.request
            }
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 422, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
      
      // Call API.
        fsnmSession.FSNMkeys() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    XCTFail("FSNMKeysAPITest:testSuccessfulResponse422: success was not expected")
                case .failure(_):
                    self.expectation?.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
