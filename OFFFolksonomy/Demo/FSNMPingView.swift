//
//  FSNMPingView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMPingViewModel: ObservableObject {
    @Published var ping = FSNMAPI.Ping()
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)

    init() {
        self.ping.ping = "initialised"
    }
    
    // get the properties
    func update() {
        // get the remote data
        fsnmAPI.fetchPing() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    self.ping.ping = post.ping ?? "ping has nil value"
                case .failure(let error):
                    self.ping.ping = "\(error)"
                }
            }
        }
    }
}

struct FSNMPingView: View {
    
    @StateObject var model = FSNMPingViewModel()

    var body: some View {
        VStack {
            Text("The Ping API allows to check whether the folksonomy server is reachable.")
            Text("ping: \(model.ping.ping!)")
                .onAppear {
                    model.update()
            }
            .navigationTitle("PingAPI")
        }
        .padding()
    }
}

struct FSNMPingView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMPingView()
    }
}
