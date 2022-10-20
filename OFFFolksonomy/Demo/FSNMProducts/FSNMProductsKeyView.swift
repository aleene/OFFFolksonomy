//
//  FSNMProductsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMProductsKeyViewModel: ObservableObject {
    @Published var products: [FSNMAPI.Product]
    @Published var error: String?
    private var offAPI = OFFAPI(urlSession: URLSession.shared)
    @Published var key = "ingredients:garlic"

    init() {
        self.products = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        FSNMAPI().fetchProducts(with: key) { (result) in
            
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.products = products
                }
            case .failure(let error):
                self.error = "\(error)"
            }
        }
    }
}

struct FSNMProductsKeyView: View {
    @StateObject var model = FSNMProductsKeyViewModel()

    var body: some View {
        Text("The ProductsAPI retrieves a list of products for a specific key.")
            .padding()
        Text("The example below uses the key \(model.key)")
        List(model.products)  { product in
            Section {
                HStack {
                    Text("product: ")
                    Text(product.product ?? "nil")
                }
                HStack {
                    Text("k: ")
                    Text(product.k ?? "nil")
                }
                HStack {
                    Text("v: ")
                    Text(product.v ?? "nil")
                }
            }
        }
        .onAppear {
            model.update()
        }
        .navigationTitle("Products API")
    }
}

struct FSNMProductsKeyView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductsKeyView()
    }
}
