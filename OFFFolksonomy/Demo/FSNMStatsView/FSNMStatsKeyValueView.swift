//
//  FSNMStatsKeyValueView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

class FSNMStatsKeyValueViewModel: ObservableObject {
    @Published var productStats: [FSNMAPI.ProductStats]
    @Published var error: String?
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)
    @Published var key = "ingredients:garlic"
    @Published var value = "no"

    init() {
        self.productStats = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        fsnmAPI.fetchStats(with: key, and: value) { (result) in
            
            switch result {
            case .success(let productStats):
                DispatchQueue.main.async {
                    self.productStats = productStats
                }
            case .failure(let error):
                self.error = "\(error)"
            }
        }
    }
}

struct FSNMStatsKeyValueView: View {

    @StateObject var model = FSNMStatsKeyValueViewModel()

    var body: some View {
        Text("The StatsAPI retrieves a list of products for a specific key and value.")
        Text("The example below uses the key \(model.key) and the value \(model.value)")
        List(model.productStats) { stats in
            Section {
                HStack {
                    Text("product: ")
                    Text(stats.product ?? "nil")
                }
                HStack {
                    Text("keys: ")
                    Text("\(stats.keys!)")
                }
                HStack {
                    Text("last_edit: ")
                    Text(stats.last_edit ?? "nil")
                }
                HStack {
                    Text("editors: ")
                    Text("\(stats.editors!)")
                }
        }
    }
        .onAppear {
            model.update()
        }
        .navigationTitle("Stats API")
    }
}

struct FSNMStatsKeyValueView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMStatsKeyValueView()
    }
}
