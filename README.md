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

### Auth API
Retrieves an authentication token for a username/password combination.
```    
func FSNMauth(username: String, password: String, completion: @escaping (_ postResult: Result<FSNM.Auth, Error>) -> Void)
```    
**Parameters:**
- username: the username of the user as registered on OpenFoodFacts
- password: the corresponding password
**Returns:**
A Result enum, with either a succes Auth Struct or an Error. The Auth Struct has the variables: **access_token** (String), which has to be passed on in other API calls; **token_type** (String).

### Delete API
Deletes a tag of a product.
```    
func FSNMdelete(_ tag: FSNM.Tag, for owner: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```    
** Parameters **
- product: the FSNM tag to be deleted
- owner: the tag owner
- token: the token of the user (get the token via the Auth API)

**Returns**
A completion block with a Result enum (success or failure) tuple. The associated value for success is a string and for the failure an Error. Or a validation error struct or error.

### Hello API
URLSession function to check whether the folksonomy server is available.
```    
func FSNMhello(completion: @escaping (_ result: Result<FSNM.Hello, Error>) -> Void)
```
** Returns :** A completion block with a Result enum (success or failure). The associated value for success is a **FSNM.Hello** struct and for the failure an Error. The **FSNM.Hello** struct has one variable: **message**

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

### Products API
Retrieves all products for a specific key and/or value.
```    
func FSNMproducts(with key: String?, and value: String?, completion: @escaping (_ result: (Result<[FSNM.Product], Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```    
**Parameters:**
- product: the barcode of the product
- k: the key of the tag
- v : the value of the tag

**Returns:**
A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Product struct and for the failure an Error. The FSNM.Product struct has the variables: product (String), the barcode of the product; k(String) the key of the tag; v (String) the value of the tag;

### Product Tags API
Retrieves all tags for a product.
```    
func FSNMtags(with barcode: OFFBarcode, and key: String?, completion: @escaping (_ result: (Result<[FSNM.Tag], Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```    
**Parameters:**
- product: the barcode of the product
- k: the key of the tag
- v: the value of the tag
- owner: the owner of the tag
- version: the tag version
- editor: the tag editor
- last_edit: the last edit date
- comment: the tag comment

**Returns:**
A completion block with a Result enum (success or failure). The associated value for success is an array of FSNM.Tag struct and for the failure an Error. The FSNM.Tag struct has the variables: product (String), the barcode of the product; k(String) the key of the tag; v (String) the value of the tag; owner (string) the owner of the tag; version (Int) the tag version; editor (String) the tag editor; last_edit: (String) the last edit date; comment (String) the tag comment.

### Post API
Function to create a tag.
```
func FSNMpostTag(_ tag: FSNM.Tag, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```
**Parameters:**
- tag: the tag to be created
- token: the token for the user. This can be retrieved with the Auth API

**Returns**
A completion block: a tuple for the two possible results. The result is either .success of .failure.
    - The first successful result (code 200) gives a String (usually "ok")
    - The second successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.

### Put API
Function to update the value for an existing tag.
```
func putTag(_ tag: FSNM.ProductTags, for editor: String?, has token: String?, completion: @escaping (_ result: (Result<String, Error>?, Result<FSNM.ValidationError, Error>?) ) -> Void)'
```
**Parameters:**
 - tag:  the tag to be updated
 - token: the token for the user. This can be retrieved with the Auth API
 
 **Return:**
 A completion block: a tuple for the two possible results. The result is either .success of .failure.
    - The first successful result (code 200) gives a String (usually "ok")
    - The second successful (result 422) result gives a FSNM.ValidationError, usually due to a missing or wrong parameter in the request.

### Stats API
Retrieves a list of products for a key and/or value and/or owner.
```
func FSNMstats(with key: String?, and value: String?, for owner: String?, has token: String?, completion: @escaping (_ result: (Result<[FSNM.Stats], Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```    
**Parameters:**
 - key: the key of the tag for which the statistics must be searched;
 - value: the key of the tag for which the statistics must be searched;
 - owner: the owner of the tag;
 - token: the token, obtained via the Auth API (required if owner is specified);
 
**Returns:**
   A completion block with a Result enum (success or failure). The associated value for success is a FSNM.Stats struct and for the failure an Error. The FSNM.Stats struct has three variables: **product** (String), the barcode of the product; **keys** (Int), the number of keys associated with the product; **last_edit** (String), the last edit date; **editors**: the number of editors associated with the product.

### Tag Versions API
Retrieves a list of versions for a product and a key.
```
func FSNMtagVersions(for barcode: OFFBarcode, with key: String, completion: @escaping (_ postResult: (Result<[FSNM.TagVersion], Error>?, Result<FSNM.ValidationError, Error>?)) -> Void)
```
**Parameters:**
- product: the barcode of the product
- k: the key of the tag
- value : the value of the tag
- editor: the editor of the tag
- last_edit: the last edit date of the tag
- comment: a comment associated with the version
- version: the version of the tag

**Returns:**
A completion block with a Result enum (success or failure). The associated value for success is a FSNM.TagVersion struct and for the failure an Error. The FSNM.TagVersion struct has the variables: product (String), the barcode of the product; k(String) the key of the tag; v (String) the value of the tag; version (Int) the version number of the tag; editor (String) the editor of this version; last_edit (String) the edit date of this version; comment (String) the associated comment for this version

## Errors
The following errors are intercepted and can be used to intercept:
- connectionFailure: impossible to connect to the folksonomy server (url?)
- notFound(404): the API path is wrong

## Testing
You can reuse the tests, to be sure you did not broke something. The tests check the URL, the folksonomy datastructures and the request responses.

## To Be Done
* error handling is at the moment rudimentary
* extend the support for owner
* auth by cookie is not implemented

## Requirements
The demo application has been tested under:
- Xcode version 13.4.1
- Swift version 15.0

## Documentation
- Folksonomy Swagger https://api.folksonomy.openfoodfacts.org/docs
