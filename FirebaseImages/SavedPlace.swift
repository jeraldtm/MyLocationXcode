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
    @EnvironmentObject var session: SessionStore
    let ref: DatabaseReference?
    let key: String
    let id: String
    let placeName: String
    let comments: String
    let latitude: String
    let longitude: String
    let timeStamp: String
    
    init(placeName: String = "", comments: String = "", latitude: String = "", longitude: String = "", key: String = "", id: String = "", timeStamp: String = ""){
        self.ref = nil
        self.key = key
        self.id = key
        self.placeName = placeName
        self.comments = ""
        self.latitude = ""
        self.longitude = ""
        self.timeStamp = ""
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
        
        guard let id = value["time"] as? String
        else{
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.id = id
        self.placeName = placeName
        self.comments = comments
        self.latitude = latitude
        self.longitude = longitude
        self.timeStamp = id
    }
    
    func toAnyObject() -> Any {
        return [
            "placeName": placeName,
        ]
    }
}

#if DEBUG
let testData = [
    SavedPlace(placeName: "Lake Street", comments: "Testing Code", latitude: "34.011286", longitude: "-116.166868", key: "key", id: "")
]
#endif
