//
//  ContentView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import SwiftUI

//var properties: [OFFFolksonomyGetProductPropertyJson] = []

class ContentViewModel: ObservableObject {
    @Published var properties: [OFFFolksonomyGetProductPropertyJson]
    
    init(status: OFFFetchStatus? = nil) {
        self.properties = []
    }
    
    // get the properties
    func update(barcode: OFFBarcode) {
        // get the remote data
        let fetchResult = OFFRequest().fetchFolksonomyProperties(for: barcode)
        switch fetchResult {
        case .loadingFailed(let string):
            print(string)
        case .success(let data):
            for element in data {
                self.properties.append(element)
            }
            self.properties = data
            print(self.properties)
        case .initialized:
            print("Not yet")
        }
    }
}
struct ContentView: View {
        
    @StateObject var model = ContentViewModel()
        
    // Show the properties
    var body: some View {
        Text(model.properties.count > 0 ? model.properties[0].product! : "no properties")
        List(model.properties) { property in
            HStack {
                Text(property.k!)
                Text(property.v!)
                Text(property.editor!)
            }
        }
        .padding()
        // load the properties. If the properties are downloaded they should be displayed
        .onAppear {
            model.update(barcode: OFFBarcode(barcode: "3760091720114"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
