//
//  FSNMProductsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMProductsViewModel: ObservableObject {
    @Published var products: [FSNMAPI.Product]
    @Published var error: String?
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)

    init() {
        self.products = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        fsnmAPI.fetchProducts(with: "ingredients:garlic" ) { (result) in
            
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

struct FSNMProductsView: View {
    @StateObject var model = FSNMStatsViewModel()

    var body: some View {
        List(model.products) {
            Text($0.product!)
        }
        .onAppear {
            model.update()
        }
        .navigationTitle("Products API")
    }
}

struct FSNMProductsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductsView()
    }
}
