//
//  FSNMStatsTest.swift
//  OFFFolksonomyTests
//
//  Created by Arnaud Leene on 20/10/2022.
//

import XCTest
@testable import OFFFolksonomy

class FSNMStatsTest: XCTestCase {

    func successfulDecodingTest() {
        let productStats0 = FSNMAPI.ProductStats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNMAPI.ProductStats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        let array = [productStats0, productsStats1]
   
        let data = try? JSONEncoder().encode(array)
                
        OFF.decodeArray(data: data, type:FSNMAPI.ProductStats.self) { (result) in
            switch result {
            case .success(let decodedProductStats):
                XCTAssertEqual(array, decodedProductStats, "FSNMPingTest:testSuccessfulResponse:Works OK.")
            case .failure(let error):
                if let error = error as? APIResponseError {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Error: \(error)")
                } else {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Incorrect error received.")
                }
            }
        }
    }

    func unsuccessfulDecodingTest() {
        let productStats0 = FSNMAPI.ProductStats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:21.65963", editors: 1)
        let productsStats1 = FSNMAPI.ProductStats(product: "0011110805805", keys: 1, last_edit: "2022-10-11T18:01:50.208173", editors: 1)
        let array = [productStats0, productsStats1]
           
        // need to figure out to use encoding
        let jsonString = """
                       [
                            {
                                "product8": "0011110805805",
                                "keys": 1,
                                "last_edit": "2022-10-11T18:01:21.65963",
                                "editors": 1
                            },
                            {
                                "product7": "0011110814395",
                                "keys": 1,
                                "last_edit": "2022-10-11T18:01:50.208173",
                                "editors": 1
                            }
                       ]
                       """
        let data = jsonString.data(using: .utf8)
        
        OFF.decodeArray(data: data, type:FSNMAPI.ProductStats.self) { (result) in
            switch result {
            case .success(let decodedProductStats):
                XCTAssertEqual(array, decodedProductStats, "FSNMPingTest:testSuccessfulResponse:Works OK.")
            case .failure(let error):
                if let error = error as? APIResponseError {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Error: \(error)")
                } else {
                    XCTFail("FSNMPingTest:testSuccessfulDecoding:Incorrect error received.")
                }
            }
        }
    }

}
