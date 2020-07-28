//
//  StoreView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/8/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import CoreLocation
import GooglePlaces

struct StoreView: View {
    @EnvironmentObject var session: SessionStore
    @State var comments: String = ""
    @State var placeName: String = ""
    @ObservedObject var locationManager = LocationManager()
    @State var image: Image? = nil
    @State var uiImage: UIImage? = nil
    @State var showCaptureImageView: Bool = false
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        NavigationView {
            if (session.session != nil){
                VStack {
                    MapView(latitude: userLatitude, longitude: userLongitude)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10.0)
                    
                    Form {
                        TextField("Place Name", text: $placeName)
                        TextField("Comments", text: $comments)
                    }
                    HStack {
                        
                        NavigationLink(destination: ListNearbyView()){
                            Text("List Nearby")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                          self.showCaptureImageView.toggle()
                        }) {
                          Text("Choose photos")
                        }.padding(10.0)
                        
                        Spacer()
                        
                        Button(action: saveLocation) {
                            Text("Save")
                        }.padding(10.0)
                    }
                    if (showCaptureImageView) {
                        CaptureImageView(isShown: $showCaptureImageView, image: $image, uiImage: $uiImage)
                            .frame(height: 300.0, alignment: .trailing)
                    }
                    
                } .navigationBarTitle(Text("Save Location"))
            } else {
                SignInView()
            }
            
        }.onAppear(perform: getUser)
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}

struct CaptureImageView {
  @Binding var isShown: Bool
  @Binding var image: Image?
    @Binding var uiImage: UIImage?
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(isShown: $isShown, image: $image, uiImage: $uiImage)
  }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
