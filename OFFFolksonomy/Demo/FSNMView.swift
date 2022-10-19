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
            Text("Stats API")
            Text("Products API")
            Text("Tags API")
            Text("Tag Versions API")
            Text("Keys API")
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
