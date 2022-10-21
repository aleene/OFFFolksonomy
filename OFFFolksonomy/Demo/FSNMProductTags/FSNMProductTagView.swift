//
//  FSNMProductTagView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

class FSNMProductTagViewModel: ObservableObject {
    @Published var productTag: FSNMAPI.ProductTags?
    @Published var error: String?
    private var offAPI = OFFAPI(urlSession: URLSession.shared)
    @Published var barcode = OFFBarcode(barcode: "3760091720115")
    @Published var key = "evolutions"

    init() {
        self.productTag = nil
    }
    
    // get the properties
    func update() {
        // get the remote data
        offAPI.fetchProductTags(with: barcode, and: key) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let productTag):
                        self.productTag = productTag[0]
                    case .failure(let error):
                        self.error = "\(error)"
                    }
                }
            }
        }
    }
}

struct FSNMProductTagView: View {
    @StateObject var model = FSNMProductTagViewModel()

    var body: some View {
        Text("Get a specific tag for a product.")
            .padding()
        Text("The example below uses the product \(model.barcode.string) and tag \(model.key)")
            Section {
                HStack {
                    Text("product: ")
                    Text(model.productTag?.product ?? "nil")
                }
                HStack {
                    Text("k: ")
                    Text(model.productTag?.k ?? "nil")
                }
                HStack {
                    Text("v: ")
                    Text(model.productTag?.v ?? "nil")
                }
                HStack {
                    Text("owner: ")
                    Text(model.productTag?.owner ?? "nil")
                }
                HStack {
                    Text("version: ")
                    Text("\(model.productTag!.version!)")
                }
                HStack {
                    Text("editor: ")
                    Text(model.productTag?.editor ?? "nil")
                }
                HStack {
                    Text("last_edit: ")
                    Text(model.productTag?.last_edit ?? "nil")
                }
                HStack {
                    Text("comment: ")
                    Text(model.productTag?.comment ?? "nil")
                }
            }
        .navigationTitle("Product Tag")
        .onAppear {
            model.update()
        }
    }
}

struct FSNMProductTagView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagView()
    }
}
