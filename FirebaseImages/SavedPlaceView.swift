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
    var savedPlace: SavedPlace
    var type: String
    
    func getType(){
        print("Type: " + self.type)
    }
    
    var body: some View {
            VStack {
                MapView(latitude: savedPlace.latitude, longitude: savedPlace.longitude)
                    .frame(height: 200)
                    .onAppear(perform: getType)
                
                if (savedPlace.containsPhoto == "True") {
                    if (type == "friend"){
                        FirebaseImage(id: session.selectedFriend.favId + "/" + savedPlace.id)
                    } else {
                        FirebaseImage(id: session.userId + "/" + savedPlace.id)
                    }
                }
                
//                if (savedPlace.containsPhoto == "True"){
//                    FirebaseImage(id: session.selectedFriend.favId + "/" + savedPlace.id)
//                }
                
                HStack {
                    Text("Name: ")
                    Text(savedPlace.placeName)
                }
                HStack {
                    Text("comments:")
                    Text(savedPlace.comments)
                }
            }.navigationBarTitle(Text(savedPlace.placeName))
    }
}

struct SavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPlaceView(savedPlace: SavedPlace(), type: "")
            .environmentObject(SessionStore())
    }
}
