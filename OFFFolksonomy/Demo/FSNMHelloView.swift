//
//  FSNMHelloView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 05/11/2022.
//

import SwiftUI

class FSNMHelloViewModel: ObservableObject {
    
    @Published var hello = FSNM.Hello()
   
    private var offSession = URLSession.shared

    init() {
        self.hello.message = "initialised"
    }
    
    // get the properties
    func update() {
        // get the remote data
        offSession.fetchHello() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    self.hello.message = post.message ?? "message has nil value"
                case .failure(let error):
                    self.hello.message = "\(error)"
                }
            }
        }
    }
    
}

struct FSNMHelloView: View {
    
    @StateObject var model = FSNMHelloViewModel()

    var body: some View {
        VStack {
            Text("The Hello API allows to check whether the folksonomy server is reachable.")
                .multilineTextAlignment(.center)
                .padding()
            FSNMDictElementView(dict: model.hello.dict)
            Spacer()
            .onAppear {
                model.update()
            }
            .navigationTitle("HelloAPI")
        }
        .padding()
    }
}

struct FSNMHelloView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMHelloView()
    }
}

fileprivate extension FSNM.Hello {
    
    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: Dictionary<String, String> {
        var temp: Dictionary<String, String> = [:]
        temp["message"] = message ?? "nil"
        return temp
    }
}
