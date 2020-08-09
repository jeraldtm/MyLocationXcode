//
//  AppView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/8/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var localStore: LocalStore
    func getUser () {
        session.listen()
    }
    
    var body: some View {
        TabView{
          
            ContentView()
              .tabItem{
                  Image(systemName: "list.dash")
                  Text("Places")
            }
            
            FriendsView()
                .tabItem{
                    Image(systemName: "person.2")
                    Text("Friends")
            }
            
            SignInView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Account")
            }
            
        }.onAppear(perform: getUser)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let session: SessionStore = SessionStore()
        let localStore: LocalStore = LocalStore()
        return AppView().environmentObject(session).environmentObject(localStore)
    }
}
