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
                .frame(height: 300)
            HStack {
                Text("Name: ")
                Text(savedPlace.placeName)
            }
            HStack {
                Text("comments:")
                Text(savedPlace.comments)
            }
        }
    }
}

struct SavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPlaceView(savedPlace: SavedPlace())
        .environmentObject(SessionStore())
    }
}
