//
//  FSNMPutTag.swift
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
    
/**
Function to update the value for an existing tag.
 
- Parameters:
 - tag:  the tag to be updated
 - token: the token for the user. This can be retrieved with the Auth API
 - completion: the completion block: a tuple for the two possible results. The result is either .success of .failure.
    - The first successful result (code 200) gives a String (usually "ok")
    - The seconds successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.
*/
    func PutProductTag(_ tag: FSNM.ProductTags, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void) {
        let request = HTTPRequest(api: .put, for: tag, having: token)

        fetchFSNMString(request: request, response: String.self) { result in
            completion(result)
            return
        }
    }
    
}
