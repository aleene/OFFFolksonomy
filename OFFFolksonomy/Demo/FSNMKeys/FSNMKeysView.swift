//
//  FSNMKeysView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI
import Collections

class FSNMKeysViewModel: ObservableObject {
    @Published var keys: [FSNM.Key]
    @Published var errorMessage: String?
    
    private var fsnmSession = URLSession.shared

    init() {
        self.keys = []
    }
    
    var keysDictArray: [OrderedDictionary<String, String>] {
        keys.map({ $0.dict })
    }

    // get the keys
    func update() {
        // get the remote data
        fsnmSession.FSNMkeys() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let keys):
                    self.keys = keys
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }
        }
    }
}

struct FSNMKeysView: View {
    @StateObject var model = FSNMKeysViewModel()

    var body: some View {
        VStack {
            if model.errorMessage == nil {
                FSNMListView(text: "All registered tags", dictArray: model.keysDictArray)
            } else {
                Text(model.errorMessage!)
            }
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

fileprivate extension FSNM.Key {
        
    private var countString : String {
        count != nil ? "\(count!)" : "nil"
    }

    private var valuesString : String {
        values != nil ? "\(values!)" : "nil"
    }

    // We like to keep the presentation order of the elements in FSNMAPI.ProductTags as it maps to the Swagger documentation
    var dict: OrderedDictionary<String, String> {
        var temp: OrderedDictionary<String, String> = [:]
        temp["k: "] = k ?? "nil"
        temp["count: "] = countString
        temp["values: "] = valuesString
        return temp
    }
}
