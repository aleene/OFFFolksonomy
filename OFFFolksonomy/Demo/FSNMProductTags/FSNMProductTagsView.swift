//
//  ContentView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import SwiftUI
import Collections

class FSNMProductTagsViewModel: ObservableObject {
    
    @Published var productTags: [FSNM.Tag]
    @Published var barcode: OFFBarcode = OFFBarcode(barcode: "")
    @Published var errorMessage: String?

    private var fsnmSession = URLSession.shared

    init() {
        self.productTags = []
    }
    
    var productTagsDictArray: [OrderedDictionary<String, String>] {
        productTags.map({ $0.dict })
    }
    
    // get the properties
    func update() {
        // get the remote data
        fsnmSession.FSNMtags(with: barcode, and: nil) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let productTags):
                        self.productTags = productTags
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                } // Add other responses here
            }
        }
    }
}

struct FSNMProductTagsView: View {
    
    @StateObject var model: FSNMProductTagsViewModel
    @State private var barcode: String = "3760091720115"
    @State private var isFetching = false
    
    // Either show a barcode input field wth the possibility to start a fetch.
    // If the fetch is doen show the results
    
    var body: some View {

        if isFetching {
            VStack {
                if let products = model.productTags {
                    
                    if !products.isEmpty {
                        FSNMListView(text: "The tags for the product with barcode \(model.barcode.barcode)", dictArray: model.productTagsDictArray)
                    } else {
                        Text("No tags for \(model.barcode.barcode) available")
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Search in progress for tags of \(model.barcode.barcode)")
                }
            }
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves the existing tags of a product.")
                .padding()
            FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
            Button(action: {
                
                model.barcode = OFFBarcode(barcode: barcode)
                model.update()
                isFetching = true
                })
            { Text("Fetch tags") }
                .font(.title)
                
            .navigationTitle("Product Tags")
            .onAppear {
                isFetching = false
            }
        }
    }
}

struct FSNMProductTagsView_Previews: PreviewProvider {
            
    static var previews: some View {
        FSNMProductTagsView(model: FSNMProductTagsViewModel())
    }
}

fileprivate extension FSNM.Tag {
    
    private var versionString : String {
        version != nil ? "\(version!)" : "nil"
    }
    
    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: OrderedDictionary<String, String> {
        var temp: OrderedDictionary<String, String> = [:]
        temp["product"] = product ?? "nil"
        temp["k"] = k ?? "nil"
        temp["v"] = v ?? "nil"
        temp["owner"] = owner ?? "nil"
        temp["version"] = versionString
        temp["editor"] = editor ?? "nil"
        temp["last_edit"] = last_edit ?? "nil"
        temp["comment"] = comment ?? "nil"
        return temp
    }
}
