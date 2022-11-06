//
//  FSNMDeleteView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 05/11/2022.
//

import SwiftUI

class FSNMDeleteViewModel: ObservableObject {
    @Published var productTag: FSNM.ProductTags?
    @Published var error: String?
    @Published var owner = ""

    @ObservedObject var authController = AuthController()

    private var fsnmSession = URLSession.shared

    // post the changes
    func update() {
        guard let validTag = productTag else { return }
        // get the remote data
        fsnmSession.deleteTag(validTag, for: authController.owner, has: authController.access_token) { (result) in
            DispatchQueue.main.async {
                if let primaryResult = result.0 {
                    switch primaryResult {
                    case .success(let suc):
                        print(suc)
                    case .failure(let error):
                        self.error = error.localizedDescription
                    }
                } // Add other responses here
            }
        }
    }

}

struct FSNMDeleteView: View {
    @StateObject var model = FSNMPostProductTagViewModel()
    // For fetching owner related fetches, authentication is required
    @ObservedObject var authController: AuthController
    
    @State private var barcode: String = ""
    @State private var tag_key: String = ""
    @State private var version: String = ""
    private var versionInteger: Int? {
        Int(version)
    }
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            Text("What to put here?")
            .navigationTitle("Tag deletion")
        } else {
            VStack {
                Text("This post allows you to add a tag to a product.")
                    .padding()
                Text("(Be sure to authenticate first)")
                FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
                FSNMInput(title: "Enter tag key", placeholder: tag_key, text: $tag_key)
                FSNMInput(title: "Enter version (integer)", placeholder: version, text: $version)
                Button(action: {
                    let productTag = FSNM.ProductTags(product: barcode,
                                                      k: tag_key,
                                                      v: nil,
                                                      owner: nil,
                                                      version: versionInteger,
                                                      editor: authController.owner,
                                                      last_edit: "",
                                                      comment: "deleted by this app")
                    model.productTag = productTag
                    model.update()
                    isFetching = true
                    } )
                    {
                        Text("Delete tag")
                        .font(.title)
                        .navigationTitle("Delete tag")
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

struct FSNMDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMDeleteView(authController: AuthController())
    }
}
