//
//  FSNMStatsKeyView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

class FSNMStatsKeyViewModel: ObservableObject {
    @Published var productStats: [FSNMAPI.ProductStats]
    @Published var error: String?
    private var offAPI = OFFAPI(urlSession: URLSession.shared)
    @Published var key = "ingredients:garlic"
    
    init() {
        self.productStats = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        offAPI.fetchStats(with: key) { (result) in
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

    var body: some View {
        Text("The StatsAPI retrieves a list of products for a specific key.")
        Text("The example below uses the key \(model.key)")
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

struct FSNMStatsKeyView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMStatsKeyView()
    }
}
