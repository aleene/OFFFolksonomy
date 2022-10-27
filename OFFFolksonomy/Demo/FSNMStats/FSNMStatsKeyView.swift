//
//  FSNMStatsKeyView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI
import Collections

class FSNMStatsKeyViewModel: ObservableObject {
    
    @Published var productStats: [FSNM.ProductStats]
    @Published var error: String?
    @Published var key = ""

    private var fsnmSession = URLSession.shared

    init() {
        self.productStats = []
    }
    
    var productStatsDictArray: [OrderedDictionary<String, String>] {
        productStats.map({ $0.dict })
    }

    // get the properties
    func update() {
        // get the remote data
        fsnmSession.fetchStats(with: key) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let productStats):
                        self.productStats = productStats
                    case .failure(let error):
                        self.error = error.localizedDescription
                    }
                } // Add other responses here
            }
        }
    }
}

struct FSNMStatsKeyView: View {
    
    @StateObject var model = FSNMStatsKeyViewModel()
    
    @State private var key: String = "ingredients:garlic"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            FSNMListView(text: "All product statistics for key \(model.key)", dictArray: model.productStatsDictArray)
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves all the product statistics for a specific key.")
                .padding()
            FSNMInput(title: "Enter key", placeholder: key, text: $key)
            Button(action: {
                
                model.key = key
                model.update()
                isFetching = true
                })
            { Text("Fetch statistics") }
                .font(.title)
                
            .navigationTitle("Products Fetch")
            .onAppear {
                isFetching = false
            }
        }
    }
}

struct FSNMStatsKeyView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMStatsKeyView()
    }
}

fileprivate extension FSNM.ProductStats {
        
    private var keysString : String {
        keys != nil ? "\(keys!)" : "nil"
    }

    private var editorsString : String {
        editors != nil ? "\(editors!)" : "nil"
    }

    // We like to keep the presentation order of the elements in FSNMAPI.ProductStats as it maps to the Swagger documentation
    var dict: OrderedDictionary<String, String> {
        var temp: OrderedDictionary<String, String> = [:]
        temp["product: "] = product ?? "nil"
        temp["keys: "] = keysString
        temp["last_edit: "] = last_edit ?? "nil"
        temp["editors: "] = editorsString
        return temp
    }
}
