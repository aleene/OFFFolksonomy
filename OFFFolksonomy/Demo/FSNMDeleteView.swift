//
//  FSNMDeleteView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 05/11/2022.
//

import SwiftUI

class FSNMDeleteTagViewModel: ObservableObject {
    @Published var productTag: FSNM.Tag?
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

struct FSNMDeleteTagView: View {
    @StateObject var model = FSNMDeleteTagViewModel()
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
                Text("This post allows you to delete a tag of a product.")
                    .padding()
                Text("(Be sure to authenticate first)")
                FSNMInput(title: "Enter barcode", placeholder: barcode, text: $barcode)
                FSNMInput(title: "Enter tag key", placeholder: tag_key, text: $tag_key)
                FSNMInput(title: "Enter version (integer)", placeholder: version, text: $version)
                Button(action: {
                    let productTag = FSNM.Tag(product: barcode,
                                              k: tag_key,
                                              v: nil,
                                              owner: nil,
                                              version: versionInteger,
                                              editor: authController.owner,
                                              last_edit: Date().ISO8601Format(),
                                              comment: "deleted by OFFFolksonomy")
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

struct FSNMDeleteTagView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMDeleteTagView(authController: AuthController())
    }
}
