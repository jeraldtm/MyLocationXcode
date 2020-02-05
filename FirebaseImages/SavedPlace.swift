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
    let placeName: String
    let id: String
    
    init(placeName: String, key: String = "", id: String = ""){
        self.ref = nil
        self.key = key
        self.placeName = placeName
        self.id = key
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let placeName = value["locationName"] as? String
            else{
                return nil
            }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.placeName = placeName
        self.id = snapshot.key
    }
    
    func toAnyObject() -> Any {
        return [
            "placeName": placeName,
        ]
    }
}
