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
            NavigationLink(destination: FSNMPingView() ) {
                Text("Ping API")
            }
            NavigationLink(destination: FSNMStatsOverView() ) {
                Text("Stats API")
            }
            NavigationLink(destination: FSNMProductsView() ) {
                Text("Products API")
            }
            Text("Tags API")
            NavigationLink(destination: FSNMProductTagVersionsView() ) {
                Text("Product Tag Versions API")
            }
            NavigationLink(destination: FSNMKeysOverView() ) {
                Text("Keys API")
            }
            Text("Delete API ")
            Text("Put API ")
            Text("Post API ")
            Text("Auth API ")
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
