//
//  FSNMStatsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMStatsViewModel: ObservableObject {
    @Published var productStats: [FSNMAPI.ProductStats]
    @Published var error: String?
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)

    init() {
        self.productStats = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        fsnmAPI.fetchStats(with: "ingredients:garlic" ) { (result) in
            
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

struct FSNMStatsView: View {
    
    @StateObject var model = FSNMStatsViewModel()

    var body: some View {
        List(model.productStats) {  stats in
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
        .onAppear {
            model.update()
        }
        .navigationTitle("Stats API")
    }
}

struct FSNMStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMStatsView()
    }
}
