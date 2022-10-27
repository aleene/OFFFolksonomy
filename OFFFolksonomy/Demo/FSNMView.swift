//
//  FSNMView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

struct FSNMView: View {
    
    @ObservedObject var authController: AuthController
    
    var body: some View {
        List {
            NavigationLink(destination: FSNMStatsOverView(authController: authController) ) {
                Text("Stats API")
            }
            NavigationLink(destination: FSNMProductsOverView() ) {
                Text("Products API")
            }
            NavigationLink(destination: FSNMProductTagsOverView() ) {
                Text("Product Tags API")
            }
            NavigationLink(destination: FSNMProductTagVersionsOverView() ) {
                    Text("Product Tag Versions API")
            }
            NavigationLink(destination: FSNMKeysOverView() ) {
                Text("Keys API")
            }
            NavigationLink(destination: FSNMPingView() ) {
                Text("Ping API")
            }
            Text("Delete API ")
            Text("Put API ")
            Text("Post API ")
            NavigationLink(destination: FSNMAuthView(authController: authController)) {
                Text("Auth API ")
            }
        }
        .navigationTitle("Folksonomy API's")
    }
}

// Give an overview of all FSNM API's
struct FSNMView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMView(authController: AuthController())
    }
}
