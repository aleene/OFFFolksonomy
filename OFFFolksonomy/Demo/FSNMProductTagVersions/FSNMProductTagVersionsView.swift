//
//  FSNMProductTagVersionsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMProductTagVersionsViewModel: ObservableObject {
    @Published var versions: [FSNMAPI.ProductTagVersions]
    @Published var error: String?
    private var offAPI = OFFAPI(urlSession: URLSession.shared)
    @Published var barcode = OFFBarcode(barcode: "3760091720115")
    @Published var key = "evolutions"

    init() {
        self.versions = []
    }
    
    // get the keys
    func update() {
        // get the remote data
        FSNMAPI().fetchProductTagVersions(for: barcode, with: key) { (result) in
            
            switch result {
            case .success(let versions):
                DispatchQueue.main.async {
                    self.versions = versions
                }
            case .failure(let error):
                self.error = "\(error)"
            }
        }
    }
}

struct FSNMProductTagVersionsView: View {
    @StateObject var model = FSNMProductTagVersionsViewModel()

    var body: some View {
        Text("The ProductTagVersions API retrieves a list of versions for a specific product and key.")
            .padding()
        Text("The example below uses the product \(model.barcode.string) and key \(model.key)")
        List(model.versions) { version in
            Section {
                HStack {
                    Text("product: ")
                    Text(version.product ?? "nil")
                }
                HStack {
                    Text("k: ")
                    Text(version.k ?? "nil")
                }
                HStack {
                    Text("v: ")
                    Text(version.v ?? "nil")
                }
                HStack {
                    Text("version: ")
                    Text("\(version.version!)")
                }
                HStack {
                    Text("editor: ")
                    Text(version.editor ?? "nil")
                }
                HStack {
                    Text("last_edit: ")
                    Text(version.last_edit ?? "nil")
                }
                HStack {
                    Text("comment: ")
                    Text(version.comment ?? "nil")
                }
            }
            .onAppear {
                model.update()
            }
            .navigationTitle("Product Tag Versions")
        }
    }
}

struct FSNMProductTagVersionsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagVersionsView()
    }
}
