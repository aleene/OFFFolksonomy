//
//  FSNMPostProductTag.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 28/10/2022.
//

import SwiftUI

class FSNMPostTagViewModel: ObservableObject {
    @Published var productTag: FSNM.ProductTags?
    @Published var error: String?
    @Published var owner = ""
    @Published var success = ""
    @ObservedObject var authController = AuthController()

    private var fsnmSession = URLSession.shared

    // post the changes
    func update() {
        guard let validTag = productTag else { return }
        // get the remote data
        fsnmSession.PostProductTag(validTag, for: authController.owner, has: authController.access_token) { (result) in
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

struct FSNMPostTagView: View {
    
    @StateObject var model = FSNMPostTagViewModel()
    // For fetching owner related fetches, authentication is required
    @ObservedObject var authController: AuthController
    
    @State private var barcode: String = ""
    @State private var tag_key: String = ""
    @State private var tag_value: String = ""
    @State private var isFetching = false

    var body: some View {
        if isFetching {
            Text("Result of post: \(model.success)")
            .navigationTitle("Tag creation")
        } else {
            VStack {
                Text("This post allows you to add a tag to a product.")
                    .padding()
                Text("(Be sure to authenticate first)")
                FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
                FSNMInput(title: "Enter tag key", placeholder: tag_key, text: $tag_key)
                FSNMInput(title: "Enter tag value", placeholder: tag_value, text: $tag_value)
                Button(action: {
                    let productTag = FSNM.ProductTags(product: barcode,
                                                      k: tag_key,
                                                      v: tag_value,
                                                      owner: nil,
                                                      version: nil,
                                                      editor: authController.owner,
                                                      last_edit: Date().ISO8601Format(),
                                                      comment: "created by this app")
                    model.productTag = productTag
                    model.update()
                    isFetching = true
                    } )
                    {
                        Text("Post tag")
                        .font(.title)
                        .navigationTitle("Post tag")
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

struct FSNMPostTagView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMPostTagView(authController: AuthController())
    }
}
