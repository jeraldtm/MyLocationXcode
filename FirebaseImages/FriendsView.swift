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
    
    func deleteFriend(at offsets: IndexSet){
        for offset in offsets{
            session.friendsRef.child(session.friends[offset].timeStamp).removeValue()
        }
    }
    
    var body: some View {
        NavigationView {
            if (session.session != nil) {
                VStack(alignment: .leading){
                List {
                    Section{
                        ForEach(self.session.friends){ friend in
                            FriendCell(friend: friend)
                                .environmentObject(self.session)
                        }
                    .onDelete(perform: deleteFriend)
                    }
                }
                .navigationBarTitle(Text("Friends"))
                .listStyle(GroupedListStyle())
                
                NavigationLink(destination: AddFriendView()) { // (7)
                  HStack {
                    Image(systemName: "plus.circle.fill") //(8)
                      .resizable()
                      .frame(width: 20, height: 20) // (11)
                    Text("Add Friend") // (9)
                  }
                }
                .padding()
                .accentColor(Color(UIColor.systemTeal))
                }
          } else {
                Text("Sign in to share places with friends!")
                    .font(.largeTitle)
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
        let session: SessionStore = SessionStore()
        return FriendsView().environmentObject(session)
        .colorScheme(.dark)
    }
}
#endif

