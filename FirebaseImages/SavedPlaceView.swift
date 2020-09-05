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
                if (self.savedPlace.containsPhoto == "True") {
                    MapView(latitude: self.savedPlace.latitude, longitude: self.savedPlace.longitude)
                        .onAppear(perform: self.getType)
                
                    if (self.type == "friend"){
                        FirebaseImage(id: self.session.selectedFriend.favId + "/" + self.savedPlace.id)
                } else {
                        FirebaseImage(id: self.session.userId + "/" + self.savedPlace.id)
                }
                } else{
                        MapView(latitude: self.savedPlace.latitude, longitude: self.savedPlace.longitude)
                }
                
                HStack {
                    Text("Name: ")
                    Text(self.savedPlace.placeName)
                }
                HStack {
                    Text("Comments:")
                    Text(self.savedPlace.comments)
                }
                
                HStack {
                    Text(self.savedPlace.timeStamp)
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
