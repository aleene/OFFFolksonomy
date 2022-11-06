//
//  File.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 06/11/2022.
//

import Foundation


/*
 curl -X 'PUT' \
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
   "last_edit": "2022-11-06T14:04:01.167Z",
   "comment": ""
 }'
 */

extension URLSession {
    
/// function to hide the intricates of the URL Stats API from the user
    func putTag(_ tag: FSNM.ProductTags, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        let request = HTTPRequest(api: .put, for: tag, having: token)

        fetchFSNMString(request: request, response: String.self) { result in
            completion(result)
            return
        }
    }
    
}
