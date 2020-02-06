//
//  SavedPlacesList.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/5/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase

struct SavedPlace: Identifiable {
    let ref: DatabaseReference?
    let key: String
    let id: String
    let placeName: String
    let comments: String
    let latitude: String
    let longitude: String
    
    init(placeName: String = "testName", comments: String = "testComment", latitude: String = "0.0", longitude: String = "0.0", key: String = "", id: String = ""){
        self.ref = nil
        self.key = key
        self.id = key
        self.placeName = ""
        self.comments = ""
        self.latitude = ""
        self.longitude = ""
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let placeName = value["locationName"] as? String
            else{
                return nil
            }
        
        guard let comments = value["comments"] as? String
        else{
            return nil
        }
        
        guard let latitude = value["latitude"] as? String
        else{
            return nil
        }
        
        guard let longitude = value["longitude"] as? String
        else{
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.id = snapshot.key
        
        self.placeName = placeName
        self.comments = comments
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    func toAnyObject() -> Any {
        return [
            "placeName": placeName,
        ]
    }
}
