//
//  ContentView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import SwiftUI

class FSNMTagsViewModel: ObservableObject {
    /*
    @Published var properties: [OFFFolksonomyGetProductPropertyJson]
    
    init(status: FSNMFetchStatus? = nil) {
        self.properties = []
    }
    
    // get the properties
    func update(barcode: OFFBarcode) {
        // get the remote data
        let fetchResult = OFFRequest().fetchFolksonomyProperties(for: barcode)
        switch fetchResult {
        case .failed(let string):
            print(string)
        case .success(let data):
            if let validData = data as? [OFFFolksonomyGetProductPropertyJson] {
                for element in validData {
                    self.properties.append(element)
                }
                self.properties = validData
                print(self.properties)
            } else {
                print("no validData")
            }
        }
    }
     */
}
struct FSNMTagsView: View {
                
    // Show the properties
    var body: some View {
        Text("")
    }
}

struct FSNMTagsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMTagsView()
    }
}
