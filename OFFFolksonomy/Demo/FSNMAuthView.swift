//
//  FSNMAuthView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 24/10/2022.
//

import SwiftUI

class FSNMAuthViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    
    @Published var hasError = false
    @Published var isSigningIn = false
    
    init() {
        self.username = ""
        self.password = ""
        
        self.hasError = false
        self.isSigningIn = false
    }
    
    var canSignIn: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func signIn() {
        guard canSignIn else { return }
    }
}

struct FSNMAuthView: View {
    
    @StateObject var model = FSNMAuthViewModel()
    
    var body: some View {
        HStack {
//            Spacer()
//            VStack {
//                VStack(alignment: .leading) {
//                    Text("Username: ")
//                    TextField("Username", text: $model.username)
//                        .autocapitalization(.none)
//                        .keyboardType(.default)
//                        .disableAutocorrection(true)
//                    Text("Password")
//                    SecureField("Password", text: $model.password)
//                }
//                .textFieldStyle(.roundedBorder)
//                .disabled(model.isSigningIn)
//
//                if model.isSigningIn {
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                } else {
//                    Button("sign In") {
//                        model.signIn()
//                    }
//                }
//                Spacer()
//            }
//            .padding()
//            .frame(maxWidth: 400.0)
//
//            Spacer()
//        }
//        .alert(isPresented: $model.hasError) {
//            Alert(
//                title: Text("Sign In Failed"),
//                message: Text("The username/password combination is invalid") )
        }
    }
}

struct FSNMAuthView_Previews: PreviewProvider {
    
    static var previews: some View {
        FSNMAuthView()
    }
    
}
