//
//  FSNMStatsKeyValueView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI
import Collections

class FSNMStatsKeyValueViewModel: ObservableObject {
    @Published var productStats: [FSNM.Stats]
    @Published var error: String?
    @Published var key = ""
    @Published var value = ""

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
        fsnmSession.FSNMstats(with: key, and: value, for: nil, has: nil) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let productStats):
                    self.productStats = productStats
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}

struct FSNMStatsKeyValueView: View {

    @StateObject var model = FSNMStatsKeyValueViewModel()
    @State private var key: String = "ingredients:garlic"
    @State private var value: String = "no"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            ListView(text: "All product statistics for key \(model.key) and value \(model.value)", dictArray: model.productStatsDictArray)
            .navigationTitle("Products")

        } else {
            Text("This fetch retrieves all the product statistics for a specific key and value.")
                .padding()
            InputView(title: "Enter key", placeholder: key, text: $key)
            InputView(title: "Enter value", placeholder: value, text: $value)
            Button(action: {
                
                model.key = key
                model.value = value
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

struct FSNMStatsKeyValueView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMStatsKeyValueView()
    }
}

fileprivate extension FSNM.Stats {
        
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
