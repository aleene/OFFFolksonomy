//
//  FSNMKeysOverView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 20/10/2022.
//

import SwiftUI

struct FSNMKeysOverView: View {
    var body: some View {
        List {
            Text("Overview of all possibilities for retrieving keys.")
            NavigationLink(destination: FSNMKeysView() ) {
                Text("Retrieve all keys")
            }
            Text("Retrieve all keys for an owner")
        }
        .navigationTitle("Keys API")
    }
}

struct FSNMKeysOverView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMKeysOverView()
    }
}
