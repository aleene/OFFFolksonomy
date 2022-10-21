//
//  FSNMProductTagsOverView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

struct FSNMProductTagsOverView: View {
    var body: some View {
        List {
            Text("Retrieve the tags for a product.")
            NavigationLink(destination: FSNMProductTagsView() ) {
                Text("For a product")
            }
            NavigationLink(destination: FSNMProductTagView() ) {
                Text("For a product and key")
            }
            NavigationLink(destination: FSNMProductTagsView() ) {
                Text("For a product and subkeys")
            }
            Text("It is also possible to use a key, a value and an owner")
        }
        .navigationTitle("Stats API's")
    }
}

struct FSNMProductTagsOverView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagsOverView()
    }
}
