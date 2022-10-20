//
//  FSNMProductsOverView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

struct FSNMProductsOverView: View {
    var body: some View {
        List {
            Text("Overview of all possibilities for retrieving products.")
            NavigationLink(destination: FSNMProductsKeyView()) {
                Text("Retrieve all products for a key")
            }
            NavigationLink(destination: FSNMProductsKeyValueView()) {
                Text("Retrieve all products for a key and value")
            }
            Text("Retrieve all products for an owner")
        }
        .navigationTitle("Products API")
    }
}

struct FSNMProductsOverView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductsOverView()
    }
}
