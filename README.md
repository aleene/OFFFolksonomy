#  OFFFolksonomy

This is an demonstration app for the various Folksonomy API's of Open Food Facts.

## Folksonomy
The folksonomy server allows users to annotate food products found on http://www.openfoodfacts.org . Annotation consists of adding a key-value pair to a barcode. 

## Demo
The demo application allows you to see the results of API-calls.

## Installation
You can reuse the libraries from this repository. The steps:
- OFF-folder - all the files in this folder should copied.
- FSNM-folder - copy only the files for the API's that you are going to use.

## Usage
### Initialisation
For all api's you need to setup an URLSession (for instance in your ViewModel), like:
'private var fsnmSession = URLSession.shared'
### Hello API
Function to check whether the folkosonomy server is available.
```    
    func FSNMhello(completion: @escaping (_ result: Result<FSNM.Hello, Error>) -> Void)
```
Returns: A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Hello struct and for the failure an Error.
### Ping API
### Put API
Function to update the value for an existing tag.
```bash
func putTag(_ tag: FSNM.ProductTags, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void)'
```
- Parameters:
 - tag:  the tag to be updated
 - token: the token for the user. This can be retrieved with the Auth API
 - completion: the completion block: a tuple for the two possible results. The result is either .success of .failure.
    - The first successful result (code 200) gives a String (usually "ok")
    - The seconds successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.

## Testing
You can reuse the tests.

## Requirements
The demo application has been tested under:
- Xcode version 13.4.1
- Swift version 15.0

## Documentation
- Folksonomy Swagger https://api.folksonomy.openfoodfacts.org/docs
