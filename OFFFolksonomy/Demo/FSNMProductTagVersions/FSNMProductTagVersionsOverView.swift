//
//  FSNMProductTagVersionsOverView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

struct FSNMProductTagVersionsOverView: View {
    var body: some View {
        List {
            Text("Get a list of all versions of a tag for a product.")
            NavigationLink(destination: FSNMProductTagVersionsView() ) {
                Text("For a product and key")
            }
            Text("It is also possible to add an owner")
        }
        .navigationTitle("Product Tag Versions API's")
    }
}

struct FSNMProductTagVersionsOverView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagVersionsOverView()
    }
}
