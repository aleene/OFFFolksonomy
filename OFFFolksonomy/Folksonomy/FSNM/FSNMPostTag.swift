//
//  FSNMPostTag.swift
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
    
/**
Function to create a tag.
- Parameters:
- tag:the tag to be created
- token: the token for the user. This can be retrieved with the Auth API
      
- Returns:
A completion block: a tuple for the two possible results. The result is either .success of .failure.
    - The first successful result (code 200) gives a String (usually "ok")
    - The second successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.

*/
    func FSNMpostTag(_ tag: FSNM.Tag, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        let request = HTTPRequest(api: .post, for: tag, having: token)

        fetchFSNMString(request: request, response: String.self) { result in
            completion(result)
            return
        }
    }
    
}
