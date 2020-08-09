//
//  AddFriendView.swift
//  FirebaseImages
//
//  Created by Thow on 8/9/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @State var friendName: String = ""
    @State var friendId: String = ""
    var body: some View {
        VStack {
            Form {
                if self.session.selectedPlace != ""{
                    Text(self.session.selectedPlace)
                } else{
                    TextField("Name", text: $friendName)
                }
                TextField("Id", text: $friendId)
            }
            HStack {
                Spacer()
                
                Button(action: {
                    if self.friendName != ""{
                        if self.friendId != ""{
                            self.addFriend()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Save")
                }.padding(10.0)
                
                Spacer()
            }
        } .navigationBarTitle(Text("Add friend"), displayMode: .inline)
    }
    
    func addFriend(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss:SS xxxxx"
        let time = formatter.string(from: Date())
        session.friendsRef.child(time).child("favName").setValue(self.friendName)
        session.friendsRef.child(time).child("favId").setValue(self.friendId)
        session.friendsRef.child(time).child("timeStamp").setValue(time)
    }
}

#if DEBUG
struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        let session: SessionStore = SessionStore()
        return AddFriendView().environmentObject(session)
    }
}
#endif
