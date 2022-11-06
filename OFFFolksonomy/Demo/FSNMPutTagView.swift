//
//  FSNMPutTagView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 06/11/2022.
//

import SwiftUI

class FSNMPutTagViewModel: ObservableObject {
    @Published var productTag: FSNM.Tag?
    @Published var error: String?
    @Published var owner = ""
    @Published var success = ""
    @ObservedObject var authController = AuthController()

    private var fsnmSession = URLSession.shared

    // post the changes
    func update() {
        guard let validTag = productTag else { return }
        // get the remote data
        fsnmSession.FSNMputTag(validTag, has: authController.access_token) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let suc):
                        self.success = suc
                    case .failure(let error):
                        self.error = error.localizedDescription
                    }
                } // Add other responses here
            }
        }
    }

}

struct FSNMPutTagView: View {
    @StateObject var model = FSNMPutTagViewModel()
    // For fetching owner related fetches, authentication is required
    @ObservedObject var authController: AuthController
    
    @State private var barcode: String = ""
    @State private var tag_key: String = ""
    @State private var tag_value: String = ""
    @State private var version: String = ""
    @State private var isFetching = false
    
    private var versionInteger: Int? {
        Int(version)
    }

    var body: some View {
        if isFetching {
            Text("Result of the put: \(model.success)")
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
