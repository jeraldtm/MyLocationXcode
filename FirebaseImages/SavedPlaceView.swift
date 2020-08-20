//
//  SavedPlaceView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/5/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct SavedPlaceView: View {
    @EnvironmentObject var session: SessionStore
    @State private var zoomed = false
    var savedPlace: SavedPlace
    var type: String
    
    func getType(){
        print("Type: " + self.type)
    }
    
    var body: some View {
            VStack {
                if (savedPlace.containsPhoto == "True") {
                    MapView(latitude: savedPlace.latitude, longitude: savedPlace.longitude)
                    .onAppear(perform: getType)
                    if (type == "friend"){
                        FirebaseImage(id: session.selectedFriend.favId + "/" + savedPlace.id)
                    } else {
                        FirebaseImage(id: session.userId + "/" + savedPlace.id)
                    }
                } else{
                    MapView(latitude: savedPlace.latitude, longitude: savedPlace.longitude)
                }
                
                HStack {
                    Text("Name: ")
                    Text(savedPlace.placeName)
                }
                HStack {
                    Text("Comments:")
                    Text(savedPlace.comments)
                }
                
                HStack {
                    Text(savedPlace.timeStamp)
                }
            }.navigationBarTitle(Text(savedPlace.placeName))
    }
}

struct SavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        let session: SessionStore = SessionStore()
        return SavedPlaceView(savedPlace: SavedPlace(placeName: "Test", comments: "Test", latitude: "1.0", longitude: "1.0", key: "1", id: "1", timeStamp: "2020:08:08", containsPhoto: "True"), type: "")
            .environmentObject(session)
    }
}
