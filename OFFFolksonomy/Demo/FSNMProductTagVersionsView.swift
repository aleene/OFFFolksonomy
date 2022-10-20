//
//  FSNMProductTagVersionsView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 19/10/2022.
//

import SwiftUI

class FSNMProductTagVersionsViewModel: ObservableObject {
    @Published var versions: [FSNMAPI.ProductTagVersions]
    @Published var error: String?
    private var fsnmAPI = FSNMAPI(urlSession: URLSession.shared)
    private let barcode = OFFBarcode(barcode: "3760091720115")
    private let key = "evolutions"

    init() {
        self.versions = []
    }
    
    // get the keys
    func update() {
        // get the remote data
        fsnmAPI.fetchProductTagVersions(for: barcode, with: key) { (result) in
            
            switch result {
            case .success(let versions):
                DispatchQueue.main.async {
                    self.versions = versions
                }
            case .failure(let error):
                self.error = "\(error)"
            }
        }
    }
}

struct FSNMProductTagVersionsView: View {
    @StateObject var model = FSNMProductTagVersionsViewModel()

    var body: some View {
        List(model.versions) {
            Text($0.v!)
        }
        .onAppear {
            model.update()
        }
        .navigationTitle("Product Tag Versions API")
    }
}

struct FSNMProductTagVersionsView_Previews: PreviewProvider {
    static var previews: some View {
        FSNMProductTagVersionsView()
    }
}
