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
        Group {
            if (session.session != nil) {
            FirebaseImage(id: "6HziDgpHnPe8eUfQMRPNJvc2s0i1")
                Button(action: session.signOut){
                    Text("Sign out")
                }
            
          } else {
            SignInView()
          }
        }.onAppear(perform: getUser)
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
