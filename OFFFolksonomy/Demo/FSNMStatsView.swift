//
//  FSNMStatsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMStatsViewModel: ObservableObject {
    @Published var products: [FSNMAPI.ProductStats]
    @Published var error: String?
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)

    init() {
        self.products = []
    }
    
    // get the properties
    func update() {
        // get the remote data
        fsnmAPI.fetchStats(with: "ingredients:garlic" ) { (result) in
            
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.products = products
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
        List(model.products) {
            Text($0.product!)
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
