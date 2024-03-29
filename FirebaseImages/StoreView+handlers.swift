//
//  StoreView+handlers.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/9/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Firebase
import GooglePlaces

extension StoreView {
    func saveLocation(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss:SS xxxxx"
        let time = formatter.string(from: Date())
        
        print(String(self.session.image != nil).capitalized)
        
        if (self.session.selectedPlace == ""){
            self.session.selectedPlace = placeName
        }
        
        let locationToSave : [String: String] = [
            "locationName": self.session.selectedPlace,
            "comments": self.comments,
            "containsPhoto": String(self.session.image != nil).capitalized,
            "latitude": userLatitude,
            "longitude": userLongitude,
            "time": time,
            "userId": session.userId,
            "userName": "",
            "photoPath": ""
        ]
        
        if (session.session != nil) {
            session.ref.child(time).setValue(locationToSave)
            if self.session.uiImage != nil{
                uploadImage(self.session.uiImage!, at: self.session.storageRef.child(time)) { (downloadURL) in
                    guard let downloadURL = downloadURL else {
                        return
                    }

                    let urlString = downloadURL.absoluteString
                    print("image url: \(urlString)")
                }
            }
        } else {
            print("save locally")
            localStore.currentIndex = localStore.currentIndex + 1
            localStore.addPlace(SavedPlace(placeName: self.session.selectedPlace, comments: self.comments, latitude: userLatitude, longitude: userLongitude, key: String(localStore.currentIndex), id: session.userId, timeStamp: time, containsPhoto: "False"))
        }
    }
    
    func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        reference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
    func getCurrentPlace(){
        var placesClient: GMSPlacesClient!
        let placeFields = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue)!
        placesClient = GMSPlacesClient.shared()
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields){(placeLikelihoodList: Array<GMSPlaceLikelihood>?, error) in
            if let error = error {
              print("An error occurred: \(error.localizedDescription)")
              return
            }

            if let placeLikelihoodList = placeLikelihoodList {
                self.session.selectedPlace = (placeLikelihoodList.first?.place.name!) ?? "nil"
              for likelihood in placeLikelihoodList {
                let place = likelihood.place
                print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
              }
            }
        }
    }
}
