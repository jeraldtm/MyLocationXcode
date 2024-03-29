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
    @State var currentPosition = CGSize(width:0, height:0)
    @State var newPosition = CGSize(width:0, height:0)
    @State var finalAmount:CGFloat = 1.0
    @State var currentAmount:CGFloat = 0.0
    init(id: String) {
        self.imageLoader = Loader(id)
    }

    @ObservedObject private var imageLoader : Loader

    var image: UIImage? {
        imageLoader.imageData.flatMap(UIImage.init)
    }

    var body: some View {
        VStack{
            if image != nil{
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(image!.size, contentMode: .fit)
                    .cornerRadius(10)
                .onTapGesture {
                    withAnimation{
                        if self.finalAmount <= 1.0 {
                            self.finalAmount = 3.5
                            self.currentAmount = 0.0
                            self.currentPosition = CGSize(width:0, height:-100)
                            self.newPosition = CGSize(width:0, height:0)
                        } else {
                            self.finalAmount = 1.0
                            self.currentAmount = 0.0
                            self.currentPosition = CGSize(width:0, height:0)
                            self.newPosition = CGSize(width:0, height:0)
                        }

                    }
                }
                .scaleEffect(self.finalAmount + self.currentAmount)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)

                .gesture(MagnificationGesture()
                    .onChanged { value in
                         if self.finalAmount + value - 1 >= 1 {
                                  self.currentAmount = value - 1
                              }
                          }
                          .onEnded { amount in
                              self.finalAmount += self.currentAmount
                          self.currentAmount = 0
                    }
                .simultaneously(with: DragGesture()
                    .onChanged({ value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    })
                    .onEnded ({ value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                        self.newPosition = self.currentPosition
                })))
            } else {
                if #available(iOS 14.0, *) {
                    ProgressView()
                } else {
                    Image(uiImage: placeholder!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                }
            }
        }
    }
}

final class Loader: ObservableObject {
    @Published var imageData: Data? = nil
    @Published var imageURL: URL? = nil
    init(_ id: String){
        // the path to the image
        let url = "users/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        
        ref.downloadURL { url, error in
          if let error = error {
              print("\(error)")
          } else {
              DispatchQueue.main.async{
                  self.imageURL = url
                  print(url ?? "test" as Any)
                  let cache = URLCache.shared
                  let request = URLRequest(url: self.imageURL!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
                  if let data = cache.cachedResponse(for: request)?.data {
                              print("got image from cache")
                              self.imageData = data
                  } else {
                      URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                          if let data = data, let response = response {
                              let cachedData = CachedURLResponse(response: response, data: data)
                              cache.storeCachedResponse(cachedData, for: request)
                              DispatchQueue.main.async {
                                  print("downloaded from internet")
                                  self.imageData = data
                              }
                          }
                      }).resume()
                  }
              }
          }
        }
//        ref.getData(maxSize: 15 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("\(error)")
//            } else {
//                DispatchQueue.main.async {
//                    self.imageData = data
//                }
//            }
//        }
    }
}

struct FirebaseImage_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "iV8JtXFfsBbQKYqNYPDARW8akE53/2018:02:12 07:16:34:66 +08:00")
        .environmentObject(SessionStore())
    }
}
