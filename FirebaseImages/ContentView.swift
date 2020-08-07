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
    @EnvironmentObject var localStore: LocalStore
    
    func getUser () {
        session.listen()
        session.setUserName()
    }
    
    func clearStoreView(){
        session.selectedPlace = ""
        session.comments = ""
        session.image = nil
        session.uiImage = nil
        session.showCaptureImageView = false
    }
    
    var body: some View {
        NavigationView {
            if (session.session != nil) {
                VStack(alignment: .leading){
                List {
                    Section{
                        ForEach(self.session.items.reversed()){ savedPlace in
                            PlaceCell(savedPlace: savedPlace)
                                .environmentObject(self.session)
                        }
                    }
                }
                .navigationBarTitle(Text("Places"))
                .listStyle(GroupedListStyle())
                
                NavigationLink(destination: StoreView()) { // (7)
                  HStack {
                    Image(systemName: "plus.circle.fill") //(8)
                      .resizable()
                      .frame(width: 20, height: 20) // (11)
                    Text("New Place") // (9)
                  }
                }
                .padding()
                .accentColor(Color(UIColor.systemTeal)) // (13)
                
                }.onAppear(perform: clearStoreView)
          } else {
                VStack(alignment: .leading){
                    List{
                        ForEach(self.localStore.items){ savedPlace in
                            PlaceCell(savedPlace: savedPlace)
                        }
                    }
                    .navigationBarTitle(Text("Places"))
                    .listStyle(GroupedListStyle())
                    
                    NavigationLink(destination: StoreView()) { // (7)
                      HStack {
                        Image(systemName: "plus.circle.fill") //(8)
                          .resizable()
                          .frame(width: 20, height: 20) // (11)
                        Text("New Place") // (9)
                      }
                    }
                    .padding()
                    .accentColor(Color(UIColor.systemTeal)) // (13)
                }.onAppear(perform: clearStoreView)
            }
        }.onAppear(perform: getUser)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PlaceCell: View {
    @EnvironmentObject var session: SessionStore
    let savedPlace: SavedPlace
    var body: some View {
        NavigationLink(destination: SavedPlaceView(savedPlace: savedPlace, type: "")
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
    }
}
#endif
