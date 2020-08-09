//
//  FriendContentView.swift
//  FirebaseImages
//
//  Created by Thow on 8/6/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct FriendContentView: View {
    @EnvironmentObject var session: SessionStore
    var selectedFriend: Friend = Friend()
    
    func getFriend () {
        session.selectedFriend = selectedFriend
        session.getFriendPlaces()
    }
    
    var body: some View {
        VStack{
            List {
                Section{
                    ForEach(self.session.friendItems.reversed()){ savedPlace in
                        FriendPlaceCell(savedPlace: savedPlace)
                            .environmentObject(self.session)
                        }
                    }
                }
            .navigationBarTitle(session.selectedFriend.favName)
            .listStyle(GroupedListStyle())
            }.onAppear(perform: getFriend)
        }
    }

struct FriendPlaceCell: View {
    @EnvironmentObject var session: SessionStore
    let savedPlace: SavedPlace
    var body: some View {
        NavigationLink(destination: SavedPlaceView(savedPlace: savedPlace, type: "friend")
            .environmentObject(session)
        ){
            VStack(alignment: .leading) {
                Text(savedPlace.placeName)
                Text(savedPlace.comments)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
struct FriendContentView_Previews: PreviewProvider {
    static var previews: some View {
        let session: SessionStore = SessionStore()
        return FriendContentView().environmentObject(session).colorScheme(.dark)
    }
}
#endif

