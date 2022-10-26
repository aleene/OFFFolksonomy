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
    @Published var auth = FSNM.Auth()
    @Published var hasError = false
    
    private var offSession = URLSession.shared

    init() {
    }
    
    var canSignIn: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func signIn() {
        guard canSignIn else { return }
        offSession.fetchAuth(username: self.username, password: self.password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let auth):
                    self.signingInDone = true
                    self.auth = auth
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
    
    var body: some View {
        Group {
            if model.signingInDone {
                VStack {
                    Text("Log in successful")
                    Text(model.auth.access_token != nil ? "\(model.auth.access_token!)" : "nil")
                    Text(model.auth.token_type != nil ? "\(model.auth.token_type!)" : "nil")
                    Button("Sign in again") {
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

                    Button("sign In") {
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
        .alert(isPresented: $model.hasError) {
            Alert(
                title: Text("Sign In Failed"),
                message: Text("The username/password combination is invalid") )
        }
    }
}

struct FSNMAuthView_Previews: PreviewProvider {
    
    static var previews: some View {
        FSNMAuthView()
    }
    
}
