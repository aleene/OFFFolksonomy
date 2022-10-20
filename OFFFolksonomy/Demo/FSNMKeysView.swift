//
//  FSNMKeysView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMKeysViewModel: ObservableObject {
    @Published var keys: [FSNMAPI.Keys]
    @Published var error: String?
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)

    init() {
        self.keys = []
    }
    
    // get the keys
    func update() {
        // get the remote data
        fsnmAPI.fetchKeys() { (result) in
            
            switch result {
            case .success(let keys):
                DispatchQueue.main.async {
                    self.keys = keys
                }
            case .failure(let error):
                self.error = "\(error)"
            }
        }
    }
}

struct FSNMKeysView: View {
    @StateObject var model = FSNMKeysViewModel()

    var body: some View {
        List(model.keys) {
            Text($0.k!)
        }
        .onAppear {
            model.update()
        }
        .navigationTitle("Keys API")
    }
}

struct FSNMKeysView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMKeysView()
    }
}
