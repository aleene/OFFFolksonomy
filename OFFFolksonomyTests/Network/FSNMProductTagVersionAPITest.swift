//
//  FSNMProductTagVersionAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 19/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMProductTagVersionAPITest: XCTestCase {

    var offAPI: OFFAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL.FSNMProductTagVersionsURL(with: OFFBarcode(barcode: "3760091720115"), and: "evolutions")

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        offAPI = OFFAPI(urlSession: URLSession.init(configuration: configuration))
        expectation = expectation(description: "Expectation")
    }

    func testSuccessfulResponse() {
        // Prepare mock json response.
        let key = "evolutions"
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
        FSNMAPI().fetchProductTagVersions(for: barcode, with: key) { (result) in
            switch result {
            case .success(let versions):
                XCTAssertEqual(versions[0].product, barcode.string, "FSNMProductTagVersionAPITest:testSuccessfulResponse:Incorrect body.")
            case .failure(let error):
                XCTFail("FSNMProductTagVersionAPITest:testSuccessfulResponse:Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
