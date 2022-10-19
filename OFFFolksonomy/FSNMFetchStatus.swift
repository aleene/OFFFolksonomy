//
//  FSNMFetchStatus.swift
//  FoodViewer
//
//  Created by aleene on 17/10/22
//

import Foundation

/** The FSNMFetchStatus describes the possible results of a get to the Folksonomy server.
 Possible values:
  - success: success: the get was succesful and the corresponding json was retrieved
  - failed: the fetch got an error message in response
*/
enum FSNMFetchStatus {
    // the json has been loaded successfully
    case success(Any)
    // the success json was not loaded
    case failed(Any) //

    /// A human readible description
    var description: String {
        switch self {
        case .success: return "Success"
        case .failed: return "Failed"
        }
    }
    
}
