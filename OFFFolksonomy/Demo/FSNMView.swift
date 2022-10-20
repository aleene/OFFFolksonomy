//
//  FSNMView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

struct FSNMView: View {
    var body: some View {
        List {
            Text("Demonstration of all API's available for Folksonomy.")
            NavigationLink(destination: FSNMPingView() ) {
                Text("Ping API")
            }
            NavigationLink(destination: FSNMStatsView() ) {
                Text("Stats API")
            }
            NavigationLink(destination: FSNMProductsView() ) {
                Text("Products API")
            }
            Text("Tags API")
            NavigationLink(destination: FSNMProductTagVersionsView() ) {
                Text("Product Tag Versions API")
            }
            NavigationLink(destination: FSNMKeysView() ) {
                Text("Keys API")
            }
            Text("Delete API ")
        }
        .navigationTitle("Folkosonomy API's")
    }
}

// Give an overview of all FSNM API's
struct FSNMView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMView()
    }
}
