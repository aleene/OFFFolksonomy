//
//  FSNMProductTagView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI
import Collections

class FSNMProductTagViewModel: ObservableObject {
    @Published var productTag: FSNM.Tag?
    @Published var errorMessage: String?
    @Published var barcode = OFFBarcode(barcode: "3760091720115")
    @Published var key = "evolutions"

    private var fsnmSession = URLSession.shared

    init() {
        self.productTag = nil
    }
    
    var productTagDictArray: [OrderedDictionary<String, String>] {
        [productTag!.dict]
    }

    // get the properties
    func update() {
        // get the remote data
        fsnmSession.FSNMtags(with: barcode, and: key) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let productTag):
                    self.productTag = productTag[0]
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }
        }
    }
}

struct FSNMProductTagView: View {
    @StateObject var model = FSNMProductTagViewModel()
    @State private var barcode: String = "3760091720115"
    @State private var key: String = "ingredients:garlic"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            FSNMListView(text: "The products with key \(model.key) ", dictArray: model.productTagDictArray)
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves the tag for a product .")
                .padding()
            FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
            FSNMInput(title: "Enter key", placeholder: key, text: $key)
            Button( action: {
                
                model.barcode = OFFBarcode(barcode: barcode)
                model.key = key
                model.update()
                isFetching = true
                } )
                { Text("Fetch tag") }
            .font(.title)
            .navigationTitle("Tag Fetch")
            .onAppear {
                isFetching = false
            }
        }

        Text("Get a specific tag for a product.")
            .padding()/*
        Text("The example below uses the product \(model.barcode.barcode) and tag \(model.key)")
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
                    Text(model.productTag?.versionString ?? "nil")
                }
                HStack {
                    Text("editor: ")
                    Text(model.productTag?.editor ?? "nil")
                }
                HStack {
                    Text("last_edit: ")
                    Text(model.productTag?.last_edit ?? "nil")
                }
                //HStack {
                //    Text("comment: ")
                 //   Text(model.productTag?.comment ?? "nil")
               }
            }*/
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
