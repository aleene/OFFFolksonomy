//
//  File.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 06/11/2022.
//

import Foundation

/* Example:
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
 Function to update a product tag.
 - Parameters:
    - tag: the FSNM.Tag that needs to be updated. This struct encodes the product barcode the key, the (new) value and the next (+1) version number.
    - token: the authentication token for the user (get via the Auth API)
 - Returns:
 A completion block: a tuple for the two possible results. The result is either .success of .failure.
 - The first successful result (code 200) gives a String (usually "ok")
 - The second successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.
*/
    func FSNMputTag(_ tag: FSNM.Tag, has token: String?, completion: @escaping (_ result: (Result<String, FSNMError>?, Result<FSNM.ValidationError, FSNMError>?) ) -> Void) {
        let request = HTTPRequest(api: .put, for: tag, having: token)

        fetchFSNMString(request: request, response: String.self) { result in
            completion(result)
            return
        }
    }
    
}
