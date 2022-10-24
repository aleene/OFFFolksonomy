//
//  FSNMProductsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI
import Collections

class FSNMProductsKeyViewModel: ObservableObject {
    @Published var products: [FSNMAPI.Product]
    @Published var error: String?
    private var offAPI = OFFAPI(urlSession: URLSession.shared)
    @Published var key = ""

    init() {
        self.products = []
    }
    
    var productsDictArray: [OrderedDictionary<String, String>] {
        products.map({ $0.dict })
    }

    // get the properties
    func update() {
        // get the remote data
        offAPI.fetchProducts(with: key) { (result) in
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

struct FSNMProductsKeyView: View {
    @StateObject var model = FSNMProductsKeyViewModel()
    @State private var key: String = "ingredients:garlic"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            FSNMListView(text: "The products with key \(model.key)", dictArray: model.productsDictArray)
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

fileprivate extension FSNMAPI.Product {
        
    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: OrderedDictionary<String, String> {
        var temp: OrderedDictionary<String, String> = [:]
        temp["product: "] = product ?? "nil"
        temp["k: "] = k ?? "nil"
        temp["v: "] = v ?? "nil"
        return temp
    }
}

