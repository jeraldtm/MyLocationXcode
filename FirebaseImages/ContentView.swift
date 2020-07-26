//
//  ContentView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/3/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    
    func getUser () {
        session.listen()
    }
    
    var body: some View {
        NavigationView {
            if (session.session != nil) {
                List {
                    Section{
                        ForEach(self.session.items.reversed()){ savedPlace in
                            PlaceCell(savedPlace: savedPlace)
                                .environmentObject(self.session)
                        }
                    }
                    
                    Section{
                        Button(action: session.signOut){
                            Text("Sign out")
                            }
                    }
                }
                .navigationBarTitle(Text("Places"))
                .listStyle(GroupedListStyle())

          } else {
            SignInView()
          }
            
        }.onAppear(perform: getUser)
        
    }
}

struct PlaceCell: View {
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(SessionStore())
    }
}
#endif
