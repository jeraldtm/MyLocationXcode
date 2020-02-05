//
//  FirebaseImage.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/4/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
let placeholder = UIImage(systemName: "star")

struct FirebaseImage : View {

    init(id: String) {
        self.imageLoader = Loader(id)
    }

    @ObservedObject private var imageLoader : Loader

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
        Image(uiImage: image ?? placeholder!)
            .resizable()
            .frame(width: 200.0, height: 200.0, alignment: .leading)

    }
}

final class Loader: ObservableObject {
    @Published var data: Data? = nil
    
    init(_ id: String){
        // the path to the image
        let url = "ProfilePics/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error)")
            }

            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}



struct FirebaseImage_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "6HziDgpHnPe8eUfQMRPNJvc2s0i1")
    }
}
