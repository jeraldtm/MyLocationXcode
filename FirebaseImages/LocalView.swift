//
//  LocalView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/3/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct LocalView: View {
    @EnvironmentObject var session: SessionStore
    
    func getUser () {
        session.listen()
    }
    
    var body: some View {
        NavigationView {
                List {
                    Section{
                        ForEach(self.session.items.reversed()){ savedPlace in
                            LocalPlaceCell(savedPlace: savedPlace)
                                .environmentObject(self.session)
                        }
                    }
                }
                .navigationBarTitle(Text("Places"))
                .listStyle(GroupedListStyle())
            
        }.onAppear(perform: getUser)
    }
}

struct LocalPlaceCell: View {
    @EnvironmentObject var session: SessionStore
    let savedPlace: SavedPlace
    
    var body: some View {
        NavigationLink(destination: SavedPlaceView(savedPlace: savedPlace)
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
struct LocalView_Previews: PreviewProvider {
    static var previews: some View {
        LocalView()
        .environmentObject(SessionStore())
    }
}
#endif
