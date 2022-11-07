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
    
    @Published var signingInDone = false
    @Published var hasError = false
    @ObservedObject var authController = AuthController()
    
    private var fsnmSession = URLSession.shared
    
    var canSignIn: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func signIn() {
        guard canSignIn else { return }
        fsnmSession.FSNMauth(username: self.username, password: self.password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let auth):
                    self.authController.access_token = auth.access_token ?? ""
                    self.authController.token_type = auth.token_type ?? ""
                    self.authController.owner = self.username
                    self.signingInDone = true
                    print(auth)
                case .failure(let x):
                    self.hasError = true
                    print(x)
                }
            }
        }
    }
}

struct FSNMAuthView: View {
    @StateObject var model = FSNMAuthViewModel()
    @ObservedObject var authController: AuthController

    var body: some View {
        Group {
            if model.signingInDone {
                VStack {
                    Text("Log in successful")
                    Text("\(authController.access_token)")
                    Text("\(authController.token_type)")
                    Button("Sign In again") {
                        model.signingInDone = false
                        model.signIn()
                    }
                    Spacer()
                }
            } else {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Username: ")
                        TextField("Username", text: $model.username)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                        Text("Password")
                        SecureField("Password", text: $model.password)
                    }
                    .textFieldStyle(.roundedBorder)
                    .disabled(model.signingInDone)

                    Button("Sign In") {
                        model.signIn()
                    }
                    .disabled(model.signingInDone)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: 400.0)
                Spacer()
            }
        }
        .onAppear() {
            model.authController = authController
        }
        .alert(isPresented: $model.hasError) {
            Alert(
                title: Text("Sign In Failed"),
                message: Text("The username/password combination is invalid") )
        }
    }
}

struct FSNMAuthView_Previews: PreviewProvider {
    
    static var previews: some View {
        FSNMAuthView(authController: AuthController())
    }
    
}
