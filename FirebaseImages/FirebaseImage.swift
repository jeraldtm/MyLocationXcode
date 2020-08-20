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
let placeholder = UIImage(systemName: "questionmark.circle")

struct FirebaseImage : View {
    @EnvironmentObject var session: SessionStore
    @State private var zoomed = false
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
            .aspectRatio(contentMode: zoomed ? .fill : .fit)
            .cornerRadius(20)
            .onTapGesture {
                withAnimation{
                    self.zoomed.toggle()
                }
            }
            .edgesIgnoringSafeArea(.all)
        
    }
}

final class Loader: ObservableObject {
    @Published var data: Data? = nil
    
    init(_ id: String){
        // the path to the image
        let url = "users/\(id)"
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
        FirebaseImage(id: "iV8JtXFfsBbQKYqNYPDARW8akE53/2018:02:12 07:16:34:66 +08:00")
        .environmentObject(SessionStore())
    }
}
