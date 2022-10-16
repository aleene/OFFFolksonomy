 //
//  OpenFoodFactsRequest.swift
//  FoodViewer
//
//  Created by arnaud on 03/02/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

class OFFRequest {
        
    enum FetchJsonResult {
        case error(String)
        case success(Data)
    }
                
    public func fetchFolksonomyProperties(for barcode: OFFBarcode) -> OFFFetchStatus {
        let result = fetch(for: barcode)
        switch result {
        case .success(let data):
            // print(String(data: data, encoding: .utf8) ?? "No json contents to show")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let product = try decoder.decode([OFFFolksonomyGetProductPropertyJson].self, from: data)
                return OFFFetchStatus.success(product)
            } catch let error {
                print(error)
                return OFFFetchStatus.loadingFailed(barcode.string)
            }

        case .error(let string):
            return OFFFetchStatus.loadingFailed(string)
        }
    }

    public func fetch(for barcode: OFFBarcode) -> FetchJsonResult {
        let fetchUrl = OFFURL.folksonomyFetch(for: barcode, with: .food)
        
            do {
                let data = try Data(contentsOf: fetchUrl, options: NSData.ReadingOptions.mappedIfSafe)
                
                return FetchJsonResult.success(data)
            } catch let error as NSError {
                print(error);
                // This error is show if the product does not have any properties
                return FetchJsonResult.error(error.description)
            }
    }
    
}
