//
//  FSNMStatsOwnerView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 27/10/2022.
//

import SwiftUI
import Collections

class FSNMStatsOwnerViewModel: ObservableObject {
    
    @Published var productStats: [FSNM.Stats]
    @Published var error: String?
    @Published var owner = ""

    @ObservedObject var authController = AuthController()

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
        fsnmSession.FSNMstats(with: nil, and: nil, for: owner, has: authController.access_token) { result in
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

struct FSNMStatsOwnerView: View {
    
    @StateObject var model = FSNMStatsOwnerViewModel()
    // For fetching owner related fetches, authentication is required
    @ObservedObject var authController: AuthController
    
    @State private var owner: String = "me"
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            FSNMListView(text: "All product statistics for owner \(model.owner)", dictArray: model.productStatsDictArray)
            .navigationTitle("Products")
        } else {
            VStack {
                Text("This fetch retrieves all the product statistics for a specific owner.")
                    .padding()
                Text("(Be sure to authenticate first)")
                FSNMInput(title: "Enter owner", placeholder: owner, text: $owner)
                Button(action: {
                    model.owner = owner
                    model.update()
                    isFetching = true
                    } )
                    {
                        Text("Fetch statistics")
                        .font(.title)
                        .navigationTitle("Products Fetch")
                        .onAppear {
                            isFetching = false
                            }
                    }
            . onAppear() {
                model.authController = authController
                owner = model.authController.owner
                }
            } // VStack
        } // else isFetching
    }
}

struct FSNMStatsOwnerView_Previews: PreviewProvider {
    

    static var previews: some View {
        FSNMStatsOwnerView(authController: AuthController())
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
