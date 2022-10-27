//
//  FSNMStatsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI


struct FSNMStatsOverView: View {
    
    @ObservedObject var authController: AuthController

    var body: some View {
        List {
            Text("Demonstration of all API's for retrieving statistics on keys and/or values.")
            NavigationLink(destination: FSNMStatsKeyView() ) {
                Text("For a key")
            }
            NavigationLink(destination: FSNMStatsKeyValueView() ) {
                Text("For a key and value")
            }
            NavigationLink(destination: FSNMStatsOwnerView(authController: authController) ) {
                Text("For an owner")
            }
            Text("It is also possible to use a key, a value and an owner")
        }
        .navigationTitle("Stats API's")
    }
}

struct FSNMStatsOverView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMStatsOverView(authController: AuthController())
    }
}
