//
//  FSNMDeleteView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 05/11/2022.
//

import SwiftUI

class FSNMDeleteTagViewModel: ObservableObject {
    @Published var productTag: FSNM.Tag?
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var owner = ""

    @ObservedObject var authController = AuthController()

    private var fsnmSession = URLSession.shared

    // post the changes
    func update() {
        guard let validTag = productTag else { return }
        // get the remote data
        fsnmSession.FSNMdelete(validTag, for: authController.owner, has: authController.access_token) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let suc):
                    self.successMessage = suc
                case .failure(let error):
                    self.errorMessage = error.description
                }
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
            VStack {
                if let success = model.successMessage {
                    Text("Result of deletion of tag with key \(tag_key) and version \(version) for product \(barcode):  \(success)" )
                } else if let error = model.errorMessage {
                    Text("Result of deletion of tag with key \(tag_key) and version \(version) for product \(barcode):  \(error)" )
                } else {
                    Text("Deletion of tag with key \(tag_key) and version \(version) for product \(barcode) in progress")
                }
            }
            .navigationTitle("Tag deletion result")
        } else {
            VStack {
                Text("This function allows you to delete a tag of a product.")
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
