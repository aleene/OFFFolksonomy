//
//  PostAPITest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 18/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class PostAPITest: XCTestCase {

    var getAPI: FSNMAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://jsonplaceholder.typicode.com/posts/42")!


    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        getAPI = FSNMAPI(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessfulResponse() {
      // Prepare mock json response.
      let userID = 5
      let id = 42
      let title = "URLProtocol Post"
      let body = "Post body...."
      let jsonString = """
                       {
                          "userId": \(userID),
                          "id": \(id),
                          "title": "\(title)",
                          "body": "\(body)"
                       }
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
        getAPI.fetchPost() { (result) in
            
            switch result {
            case .success(let post):
                XCTAssertEqual(post.userId!, userID, "Incorrect userID.")
                XCTAssertEqual(post.id!,  id, "Incorrect id.")
                XCTAssertEqual(post.title!, title, "Incorrect title.")
                XCTAssertEqual(post.body!, body, "Incorrect body.")
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testParsingFailure() {
        // Prepare mock response
        let data = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API
        getAPI.fetchPost() { (result) in
            switch result {
            case .success(_):
                XCTFail("Success response was not expected.")
            case .failure(let error):
                guard let error = error as? APIResponseError else {
                    XCTFail("Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertEqual(error, APIResponseError.parsing, "Parsing error was expected.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
