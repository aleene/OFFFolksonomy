//
//  FSNMPingView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI
import Collections

class FSNMPingViewModel: ObservableObject {
    
    @Published var ping = FSNM.Ping()
    @Published var errorMessage: String?
    
    private var offSession = URLSession.shared

    init() {
        self.ping.ping = "initialised"
    }
    
    // get the properties
    func update() {
        // get the remote data
        offSession.FSNMping() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    self.ping.ping = post.ping ?? "ping has nil value"
                case .failure(let error):
                    self.errorMessage = error.description
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
                .multilineTextAlignment(.center)
                .padding()
            if model.errorMessage == nil {
                FSNMDictElementView(dict: model.ping.dict)
            } else {
                Text(model.errorMessage!)
            }
            Spacer()
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

fileprivate extension FSNM.Ping {
    
    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: Dictionary<String, String> {
        var temp: Dictionary<String, String> = [:]
        temp["ping"] = ping ?? "nil"
        return temp
    }
}
