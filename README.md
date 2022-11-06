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
```    
private var fsnmSession = URLSession.shared
```    
### Hello API
URLSession function to check whether the folksonomy server is available.
```    
    func FSNMhello(completion: @escaping (_ result: Result<FSNM.Hello, Error>) -> Void)
```
**Returns:** A completion block with a Result enum (success or failure). The associated value for success is a **FSNM.Hello** struct and for the failure an Error. The **FSNM.Hello** struct has one variable: **message**

### Keys API
Retrieves the list of all keys on the folksonomy server with statistics.

```
func FSNMkeys(completion: @escaping (_ result: (Result<[FSNM.Keys], Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```
**Returns:** A completion block with a Result enum (success or failure). The associated value for success is an array of **FSNM.Key** struct and for the failure an Error. The **FSNM.Key** structure has three variables: **k** (String), the name of the key; **count** (Int), the numer of occurences; **values** (Int), the numer of associated values.

### Ping API
URLSession function to check whether the folksonomy server is available.
```    
func FSNMping(completion: @escaping (_ result: Result<FSNM.Ping, Error>) -> Void)
```    
**Returns:**
A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Ping struct and for the failure an Error.
**Data:** The **FSNM.Ping** datastructure is received upon a succesful fetch. **FSNM.Ping** has only one variable: **ping** (String), which will contain a timestamp put by the folksonomy server.

### Put API
Function to update the value for an existing tag.
```
func putTag(_ tag: FSNM.ProductTags, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void)'
```
- Parameters:
 - tag:  the tag to be updated
 - token: the token for the user. This can be retrieved with the Auth API
 - completion: the completion block: a tuple for the two possible results. The result is either .success of .failure.
    - The first successful result (code 200) gives a String (usually "ok")
    - The seconds successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.

### Stats API
Retrieves a list of products for a key and/or value and/or owner.
```
func FSNMstats(with key: String?, and value: String?, for owner: String?, has token: String?, completion: @escaping (_ result: (Result<[FSNM.Stats], Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```    
**Parameters:**
 - key: the key of the tag for which the statistics must be searched
 - value: the key of the tag for which the statistics must be searched
 - owner:
 - token: the token, obtained via the Auth API
**returns:**
   A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Stats struct and for the failure an Error. The FSNM.Stats struct has three variables: **product** (String), the barcode of the product; **keys** (Int), the number of keys associated with the product; **last_edit** (String), the last edit date; **editors**: the number of editors associated with the product.

## Testing
You can reuse the tests.

## Requirements
The demo application has been tested under:
- Xcode version 13.4.1
- Swift version 15.0

## Documentation
- Folksonomy Swagger https://api.folksonomy.openfoodfacts.org/docs
