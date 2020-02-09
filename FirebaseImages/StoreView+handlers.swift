//
//  StoreView+handlers.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/9/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Firebase


extension StoreView {
    func getUser () {
        session.listen()
    }
       
    func saveLocation(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd hh:mm:ss:SS xxxxx"
        let time = formatter.string(from: Date())
        
        let locationToSave : [String: String] = [
            "locationName": placeName,
            "comments": comments,
            "containsPhoto": "True",
            "latitude": userLatitude,
            "longitude": userLongitude,
            "time": time,
            "userId": session.userId,
            "userName": "",
            "photoPath": ""
        ]
        session.ref.child(time).setValue(locationToSave)
        uploadImage(self.uiImage!, at: self.session.storageRef.child(time)) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }

            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
    
    func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }

        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
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
}
