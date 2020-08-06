//
//  FriendsView.swift
//  FirebaseImages
//
//  Created by Thow on 8/6/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var session: SessionStore
    func getUser () {
        session.listen()
    }
    
    var body: some View {
        NavigationView {
            if (session.session != nil) {
                List {
                    Section{
                        ForEach(self.session.friends){ friend in
                            FriendCell(friend: friend)
                                .environmentObject(self.session)
                        }
                    }
                    
                    Section{
                        Button(action: session.signOut){
                            Text("Sign out")
                            }
                    }
                }
                .navigationBarTitle(Text("Friends"))
                .listStyle(GroupedListStyle())

          } else {
                Text("Sign in to share places with friends!")
                .font(.headline)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
          }
        }.onAppear(perform: getUser)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FriendCell: View {
    @EnvironmentObject var session: SessionStore
    let friend: Friend
    var body: some View {
        NavigationLink(destination: FriendContentView(selectedFriend: friend)
            .environmentObject(session)
        ){
            VStack(alignment: .leading) {
                Text(friend.favName)
            }
        }
    }
}

#if DEBUG
struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
        .environmentObject(SessionStore())
    }
}
#endif

