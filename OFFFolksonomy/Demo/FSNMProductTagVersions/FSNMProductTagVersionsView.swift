//
//  FSNMProductTagVersionsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI
import Collections

class FSNMProductTagVersionsViewModel: ObservableObject {
    @Published var versions: [FSNM.TagVersion]?
    @Published var errorMessage: String?
    @Published var barcode = OFFBarcode(barcode: "")
    @Published var key = ""

    private var fsnmSession = URLSession.shared
    
    var productTagVersionsDictArray: [OrderedDictionary<String, String>] {
        if let validVersions = versions {
            return validVersions.map({ $0.dict })
        } else {
            return []
        }

    }

    // get the keys
    func update() {
        // get the remote data
        fsnmSession.FSNMtagVersions(for: barcode, with: key) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let versions):
                        self.versions = versions
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                } // Add other responses here
            }
        }
    }
}

struct FSNMProductTagVersionsView: View {
    
    @StateObject var model = FSNMProductTagVersionsViewModel()
    @State private var key: String = "ingredients:garlic"
    @State private var barcode: String = "3760091720115"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            VStack {
                if let products = model.versions {
                    if !products.isEmpty {
                        FSNMListView(text: "All versions the barcode \(model.barcode.barcode) and for key \(model.key)", dictArray: model.productTagVersionsDictArray)
                    } else {
                        Text("No versions for the barcode \(model.barcode.barcode) and for key  \(model.key) available")
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Search in progress for versions for the barcode \(model.barcode.barcode) and for key \(model.key)")
                }
            }
            .navigationTitle("Versions")

        } else {
            Text("This fetch retrieves all the versions of a tag for a specific barcode and key.")
                .padding()
            FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
            FSNMInput(title: "Enter key", placeholder: key, text: $key)
            Button(action: {
                
                model.barcode = OFFBarcode(barcode: barcode)
                model.key = key
                model.update()
                isFetching = true
                })
            { Text("Fetch versions") }
                .font(.title)
                
            .navigationTitle("Versions Fetch")
            .onAppear {
                isFetching = false
            }
        }

    }
}

struct FSNMProductTagVersionsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagVersionsView()
    }
}

fileprivate extension FSNM.TagVersion {
    
    private var versionString : String {
        version != nil ? "\(version!)" : "nil"
    }
    
    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: OrderedDictionary<String, String> {
        var temp: OrderedDictionary<String, String> = [:]
        temp["product"] = product ?? "nil"
        temp["k"] = k ?? "nil"
        temp["v"] = v ?? "nil"
        temp["version"] = versionString
        temp["editor"] = editor ?? "nil"
        temp["last_edit"] = last_edit ?? "nil"
        temp["comment"] = comment ?? "nil"
        return temp
    }
}
