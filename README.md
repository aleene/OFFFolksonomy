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
### Stats API
### Ping API
## Testing
You can reuse the tests.

## Requirements
The demo application has been tested under:
- Xcode version 13.4.1
- Swift version 15.0

## Documentation
- Folksonomy Swagger https://api.folksonomy.openfoodfacts.org/docs
