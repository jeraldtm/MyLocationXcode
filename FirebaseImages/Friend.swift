//
//  Friend.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/5/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase

struct Friend: Identifiable {
    @EnvironmentObject var session: SessionStore
    let ref: DatabaseReference?
    let key: String
    let id: String
    let favId: String
    let favName: String
    let timeStamp: String
    
    init(favId: String = "", favName: String = "", key: String = "", id: String = "", timeStamp: String = ""){
        
        self.ref = nil
        self.key = key
        self.id = key
        self.favId = favId
        self.favName = favName
        self.timeStamp = timeStamp
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let favName = value["favName"] as? String
            else{
                return nil
            }
        
        guard let timeStamp = value["timeStamp"] as? String
            else{
                return nil
        }
        
        guard let favId = value["favId"] as? String
        else{
            return nil
        }
        
        guard let id = value["favId"] as? String
        else{
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.id = id
        self.favId = favId
        self.favName = favName
        self.timeStamp = timeStamp
    }
    
    func toAnyObject() -> Any {
        return [
            "favName": favName,
        ]
    }
}

#if DEBUG
let testFriend = [
    Friend(favId: "testFavId", favName: "testFriend", key: "key", timeStamp: "testTime")
]
#endif
