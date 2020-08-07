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
    @EnvironmentObject var localStore: LocalStore
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @State var placename: String = ""
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
                VStack {
                    Form {
                        if self.session.selectedPlace != ""{
                            Text(self.session.selectedPlace)
                        } else{
                            TextField("Place Name", text: $placename)
                        }
                        TextField("Comments", text: $session.comments)
                    }
                    
                    MapView(latitude: userLatitude, longitude: userLongitude)
                    session.image?
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10.0)
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: ListNearbyView()){
                            Text("List Nearby")
                        }
                        
                        if (session.session != nil) {
                            Spacer()
                            Button(action: {
                                self.session.showCaptureImageView.toggle()
                            }) {
                              Text("Choose photos")
                            }.padding(10.0)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.saveLocation()
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }) {
                            Text("Save")
                        }.padding(10.0)
                        
                        Spacer()
                    }
                    if (self.session.showCaptureImageView) {
                        CaptureImageView(isShown: $session.showCaptureImageView, image: $session.image, uiImage: $session.uiImage)
                            .frame(height: 300.0, alignment: .trailing)
                    }
                } .navigationBarTitle(Text("Save Location"), displayMode: .inline)
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
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) ->
        UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .camera
            return picker
        }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
    }
}
