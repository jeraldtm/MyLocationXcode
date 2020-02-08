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
    
    var body: some View {
            VStack {
                MapView(latitude: savedPlace.latitude, longitude: savedPlace.longitude)
                    .frame(height: 200)
                FirebaseImage(id: session.userId + "/" + savedPlace.id)
                .cornerRadius(10)
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
        SavedPlaceView(savedPlace: SavedPlace(placeName: "test", comments: "test", latitude: "34.011286", longitude: "-116.166868", key: "test", id: "iV8JtXFfsBbQKYqNYPDARW8akE53"))
            .environmentObject(SessionStore())
    }
}
