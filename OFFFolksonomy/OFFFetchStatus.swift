//
//  ProductFetchStatus.swift
//  FoodViewer
//
//  Created by arnaud on 11/05/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

/// The OFFFetchStatus describes the possible status changes of the remoteProduct
enum OFFFetchStatus {
    // the fetch has not yet been started
    case initialized
    // the product has been loaded successfully and can be set.
    case success([OFFFolksonomyGetProductPropertyJson])
    // available implies that the product has been retrieved and is available for usage
    case loadingFailed(String) // (barcodeString)

    var description: String {
        switch self {
        case .initialized: return "Initialized"
        case .success: return "IsLoaded"
        case .loadingFailed: return "LoadingFailed"
        }
    }
    
}
