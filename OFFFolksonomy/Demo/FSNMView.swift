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
        VStack {
        Group {
            NavigationLink(destination: FSNMHelloView() ) {
                Text("Hello API")
            }
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
        }
        Group {
            NavigationLink(destination: FSNMKeysOverView() ) {
                Text("Keys API")
            }
            NavigationLink(destination: FSNMPingView() ) {
                Text("Ping API")
            }
            NavigationLink(destination: FSNMDeleteView(authController: authController) ) {
                Text("Delete API ")
            }
            Text("Put API ")
            NavigationLink(destination: FSNMPostProductTagView(authController: authController) ) {
                Text("Post API ")
            }
            NavigationLink(destination: FSNMAuthView(authController: authController) ) {
                Text("Auth API ")
            }
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
