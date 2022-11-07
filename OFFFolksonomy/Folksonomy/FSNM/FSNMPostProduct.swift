//
//  FSNMPostProduct.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 27/10/2022.
//

import Foundation

/*
 curl -X 'POST' \
   'https://api.folksonomy.openfoodfacts.org/product' \
   -H 'accept: application/json' \
   -H 'Content-Type: application/json' \
   -d '{
   "product": "string",
   "k": "string",
   "v": "string",
   "owner": "",
   "version": 1,
   "editor": "string",
   "last_edit": "2022-10-27T16:21:41.527Z",
   "comment": ""
 }'
 */

extension URLSession {
    
/// function to hide the intricates of the URL Stats API from the user
    func FSNMpostTag(_ tag: FSNM.Tag, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        let request = HTTPRequest(api: .post, for: tag, having: token)

        fetchFSNMString(request: request, response: String.self) { result in
            completion(result)
            return
        }
    }
    
}
