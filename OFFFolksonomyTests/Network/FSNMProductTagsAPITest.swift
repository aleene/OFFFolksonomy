//
//  FSNMProductTagsAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMProductTagsAPITest: XCTestCase {

    var fsnmSession: URLSession!
    var expectation: XCTestExpectation!
    let apiURL = HTTPRequest(api: .tags, for: "3760091720115", with: nil, and: nil, by: nil, having: nil).url!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fsnmSession = URLSession(configuration: configuration)
        
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
        let barcode = OFFBarcode(barcode: "3760091720115")
        let jsonString = """
                       [
                         {
                           "product": "3760091720115",
                           "k": "evolutions",
                           "v": "2",
                           "owner": "",
                           "version": 1,
                           "editor": "aleene",
                           "last_edit": "2022-04-18T10:37:22.75488",
                           "comment": ""
                         },
                         {
                           "product": "3760091720115",
                           "k": "vintage",
                           "v": "2015",
                           "owner": "",
                           "version": 1,
                           "editor": "aleene",
                           "last_edit": "2022-10-13T15:58:30.248423",
                           "comment": ""
                         }
                       ]
                       """
            let data = jsonString.data(using: .utf8)
      
        MockURLProtocol.requestHandler = { request in
                guard let url = request.url,
                  url == self.apiURL else {
                throw FSNMError.request
            }
        
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
      
        // Call API.
        fsnmSession.FSNMtags(with: barcode, and: nil) { (result) in
            DispatchQueue.main.async {
                    switch result {
                   case .success(_):
                       self.expectation?.fulfill()
                   case .failure(let error):
                       XCTFail("FSNMKeysAPITest:testSuccessfulResponse:Error was not expected: \(error)")
                   }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
