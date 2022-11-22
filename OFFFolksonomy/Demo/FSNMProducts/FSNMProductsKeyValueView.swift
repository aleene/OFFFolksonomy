//
//  FSNMProductsKeyValueView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI
import Collections

class FSNMProductsKeyValueViewModel: ObservableObject {
    @Published var products: [FSNM.Product]?
    @Published var errorMessage: String?
    @Published var key = ""
    @Published var value = ""

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
        fsnmSession.FSNMproducts(with: key, and: value) { (result) in
            DispatchQueue.main.async {
                    switch result {
                    case .success(let products):
                        self.products = products
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                }
            }
        }
    }

struct FSNMProductsKeyValueView: View {
    @StateObject var model = FSNMProductsKeyValueViewModel()
    @State private var key: String = "ingredients:garlic"
    @State private var value: String = "no"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            VStack {
                if let products = model.products {
                    
                    if !products.isEmpty {
                        ListView(text: "The products with key \(model.key) and value \(model.value)", dictArray: model.productsDictArray)
                    } else {
                        Text("No products with \(model.key) and value \(model.value) available")
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Search in progress for products with key \(model.key) and value \(model.value)")
                }
            }
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves all the products for a specific key and value.")
                .padding()
            InputView(title: "Enter key", placeholder: key, text: $key)
            InputView(title: "Enter value", placeholder: value, text: $value)
            Button(action: {
                
                model.key = key
                model.value = value
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

struct FSNMProductsKeyValueView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductsKeyValueView()
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
