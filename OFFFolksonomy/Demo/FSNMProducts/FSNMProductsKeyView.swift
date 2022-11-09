//
//  FSNMProductsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI
import Collections

class FSNMProductsKeyViewModel: ObservableObject {
    @Published var products: [FSNM.Product]?
    @Published var errorMessage: String?
    @Published var key = ""

    private var fsnmSession = URLSession.shared
    
    var productsDictArray: [OrderedDictionary<String, String>] {
        if let validProducts = products {
            return validProducts.map({ $0.dict })
        } else {
            return []
        }
    }

    // get the properties
    func update() {
        // get the remote data
        fsnmSession.FSNMproducts(with: key, and: nil) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let products):
                        self.products = products
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                } // Add other responses here
            }
        }
    }
}

struct FSNMProductsKeyView: View {
    
    @StateObject var model = FSNMProductsKeyViewModel()
    @State private var key: String = "ingredients:garlic"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            VStack {
                if let products = model.products {
                    
                    if !products.isEmpty {
                        FSNMListView(text: "The products with key \(model.key)", dictArray: model.productsDictArray)
                    } else {
                        Text("No products with \(model.key) available")
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Search in progress for products with key \(model.key)")
                }
            }
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves all the products for a specific key.")
                .padding()
            FSNMInput(title: "Enter key", placeholder: key, text: $key)
            Button(action: {
                
                model.key = key
                model.update()
                isFetching = true
                })
            { Text("Fetch products") }
                .font(.title)
                
            .navigationTitle("Products Fetch")
            .onAppear {
                isFetching = false
            }
        }
    }
}

struct FSNMProductsKeyView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductsKeyView()
    }
}

fileprivate extension FSNM.Product {
        
    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: OrderedDictionary<String, String> {
        var temp: OrderedDictionary<String, String> = [:]
        temp["product: "] = product ?? "nil"
        temp["k: "] = k ?? "nil"
        temp["v: "] = v ?? "nil"
        return temp
    }
}

