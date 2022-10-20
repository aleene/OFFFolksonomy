//
//  FSNMProductTagsAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMProductTagsAPITest: XCTestCase {

    var fsnmAPI: FSNMAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL.FSNMProductTagsURL(with: OFFBarcode(barcode: "3760091720115"))

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fsnmAPI = FSNMAPI(urlSession: URLSession.init(configuration: configuration))
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
            throw APIResponseError.request
        }
        
        let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (response, data)
      }
      
      // Call API.
        fsnmAPI.fetchProductTags(with: barcode) { (result) in
            
            switch result {
            case .success(let tags):
                XCTAssertEqual(tags[0].product, barcode.string, "FSNMProductTagVersionAPITest:testSuccessfulResponse:Incorrect body.")
            case .failure(let error):
                XCTFail("FSNMProductTagVersionAPITest:testSuccessfulResponse:Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testParsingFailure() {
        let key = "evolutions"
        let barcode = OFFBarcode(barcode: "3760091720115")
        // Prepare mock json response.
        let jsonString = """
                       [
                         {
                           "product": "3760091720115",
                           "key": "here is a wrong key",
                           "v": "2",
                           "owner": "",
                           "version": 1,
                           "editor": "aleene",
                           "last_edit": "2022-04-18T10:37:22.75488",
                           "comment": ""
                         }
                       ]
                       """
        let data = jsonString.data(using: .utf8)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API
        fsnmAPI.fetchProductTagVersions(for: barcode, with: key) { (result) in
            switch result {
            case .success(let versions):
                print("versions", versions)
                XCTFail("FSNMProductTagVersionAPITest:testParsingFailure:Success response was not expected.")
            case .failure(let error):
                guard let error = error as? APIResponseError else {
                    XCTFail("FSNMProductTagVersionAPITest:testParsingFailure:Incorrect error received.")
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
