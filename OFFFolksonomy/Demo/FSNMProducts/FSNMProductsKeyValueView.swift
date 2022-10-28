//
//  FSNMProductsKeyValueView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI
import Collections

class FSNMProductsKeyValueViewModel: ObservableObject {
    @Published var products: [FSNM.Product]
    @Published var error: String?
    @Published var key = ""
    @Published var value = ""

    private var fsnmSession = URLSession.shared

    init() {
        self.products = []
    }
    
    var productsDictArray: [OrderedDictionary<String, String>] {
        products.map({ $0.dict })
    }

    // get the properties
    func update() {
        // get the remote data
        fsnmSession.fetchProducts(with: key, and: value) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                       case .success(let products):
                           self.products = products
                       case .failure(let error):
                           self.error = error.localizedDescription
                       }
                   } // Add other responses here
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
            FSNMListView(text: "The products with key \(model.key) and value \(model.value)", dictArray: model.productsDictArray)
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves all the products for a specific key and value.")
                .padding()
            FSNMInput(title: "Enter key", placeholder: key, text: $key)
            FSNMInput(title: "Enter value", placeholder: value, text: $value)
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
