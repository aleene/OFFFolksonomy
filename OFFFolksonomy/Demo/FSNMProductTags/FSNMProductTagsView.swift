//
//  ContentView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import SwiftUI

class FSNMProductTagsViewModel: ObservableObject {
    @Published var productTags: [FSNMAPI.ProductTags]
    @Published var error: String?
    private var offAPI = OFFAPI(urlSession: URLSession.shared)
    @Published var barcode = OFFBarcode(barcode: "3760091720115")

    init() {
        self.productTags = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        offAPI.fetchProductTags(with: barcode) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let productTags):
                        self.productTags = productTags
                    case .failure(let error):
                        self.error = error.localizedDescription
                    }
                } // Add other responses here
            }
        }
    }
}

struct FSNMProductTagsView: View {
    @StateObject var model = FSNMProductTagsViewModel()

    var body: some View {
        Text("Get a list of existing tags for a product.")
            .padding()
        Text("The example below uses the product \(model.barcode.string)")
        List(model.productTags) { tag in
            Section {
                HStack {
                    Text("product: ")
                    Text(tag.product ?? "nil")
                }
                HStack {
                    Text("k: ")
                    Text(tag.k ?? "nil")
                }
                HStack {
                    Text("v: ")
                    Text(tag.v ?? "nil")
                }
                HStack {
                    Text("owner: ")
                    Text(tag.owner ?? "nil")
                }
                HStack {
                    Text("version: ")
                    Text("\(tag.version!)")
                }
                HStack {
                    Text("editor: ")
                    Text(tag.editor ?? "nil")
                }
                HStack {
                    Text("last_edit: ")
                    Text(tag.last_edit ?? "nil")
                }
                HStack {
                    Text("comment: ")
                    Text(tag.comment ?? "nil")
                }
            }
        }
        .navigationTitle("Product Tags")
        .onAppear {
            model.update()
        }
    }
}

struct FSNMProductTagsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagsView()
    }
}
