//
//  FSNMPutTagView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 06/11/2022.
//

import SwiftUI

class FSNMPutTagViewModel: ObservableObject {
    @Published var productTag: FSNM.Tag?
    @Published var errorMessage: String?
    @Published var owner = ""
    @Published var success: String?
    @ObservedObject var authController = AuthController()

    private var fsnmSession = URLSession.shared

    // post the changes
    func update() {
        guard let validTag = productTag else { return }
        // get the remote data
        fsnmSession.FSNMputTag(validTag, has: authController.access_token) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let suc):
                    self.success = suc
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }
        }
    }

}

struct FSNMPutTagView: View {
    @StateObject var model = FSNMPutTagViewModel()
    // For fetching owner related fetches, authentication is required
    @ObservedObject var authController: AuthController
    
    @State private var barcode = ""
    @State private var tag_key = ""
    @State private var tag_value = ""
    @State private var version = ""
    @State private var isFetching = false
    
    private var versionInteger: Int? {
        !version.isEmpty ? Int(version) : nil
    }

    var body: some View {
        if isFetching {
            VStack {
                if let success = model.success {
                    Text("Result of putting tag with \(tag_key) and value \(tag_value) for product \(barcode): \(success)")
                } else if let error = model.errorMessage {
                    Text("Result of putting tag with \(tag_key) and value \(tag_value) for product \(barcode): \(error)")
                } else {
                    Text("Busy putting tag with \(tag_key) and value \(tag_value) for product \(barcode)")
                }
            }
            .navigationTitle("Tag edit")
        } else {
            VStack {
                Text("This post allows you to change the value of a tag for a product.")
                    .padding()
                Text("(Be sure to authenticate first)")
                FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
                FSNMInput(title: "Enter tag key", placeholder: tag_key, text: $tag_key)
                FSNMInput(title: "Enter tag value", placeholder: tag_value, text: $tag_value)
                FSNMInput(title: "Enter new version", placeholder: version, text: $version)
                Button(action: {
                    let productTag = FSNM.Tag(product: barcode,
                                                      k: tag_key,
                                                      v: tag_value,
                                                      owner: nil,
                                                      version: versionInteger,
                                                      editor: authController.owner,
                                                      last_edit: Date().ISO8601Format(),
                                                      comment: "created by OFFFolksonomy")
                    model.productTag = productTag
                    model.update()
                    isFetching = true
                    } )
                    {
                        Text("Edit tag")
                        .font(.title)
                        .navigationTitle("Edit tag")
                        .onAppear {
                            isFetching = false
                            }
                    }
            . onAppear() {
                model.authController = authController
                }
            } // VStack
        } // else isFetching
    }
}

struct FSNMPutTagView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMPutTagView(authController: AuthController())
    }
}
