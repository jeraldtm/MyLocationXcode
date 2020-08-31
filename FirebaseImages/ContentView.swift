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
    }
    
    func clearStoreView(){
        session.selectedPlace = ""
        session.comments = ""
        session.image = nil
        session.uiImage = nil
        session.showCaptureImageView = false
    }
    
    func deletePlace(at offsets: IndexSet){
        for offset in offsets{
            session.ref.child(session.items.reversed()[offset].timeStamp).removeValue()
            session.storageRef.child(session.items.reversed()[offset].timeStamp).delete { error in
              if let error = error {
                print(error.localizedDescription)
              } else {
                print(self.session.items.reversed()[offset].timeStamp + " deleted")
              }
            }
        }
    }
    
    func deleteLocalPlace(at offsets: IndexSet){
        localStore.items.remove(atOffsets: offsets)
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
                    .onDelete(perform: deletePlace)
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
                        .onDelete(perform: deleteLocalPlace)
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
        }
        .onAppear(perform: getUser)
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
        let session: SessionStore = SessionStore()
        let localStore: LocalStore = LocalStore()
        return ContentView().environmentObject(session).environmentObject(localStore).colorScheme(.dark)
            .environment(\.locale, Locale(identifier: "ar"))
    }
}
#endif
