//
//  OFFFolksonomyApp.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 13/10/2022.
//

import SwiftUI

@main

struct OFFFolksonomyApp: App {
        
    /// Every API call should get the tokens here
    @StateObject private var authController = AuthController()
    
    var body: some Scene {
        WindowGroup {
            NavigationView() {
                FSNMView(authController: authController)
            }
        }
    }
}
