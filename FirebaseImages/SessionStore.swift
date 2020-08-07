//
//  SessionStore.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/3/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var items: [SavedPlace] = []
    @Published var userId: String = ""
    @Published var userName: String = ""
    
    @Published var selectedPlace: String = ""
    @Published var comments: String = ""
    @Published var image: Image? = nil
    @Published var uiImage: UIImage? = nil
    @Published var showCaptureImageView: Bool = false
    
    @Published var friendItems: [SavedPlace] = []
    @Published var friends: [Friend] = []
    @Published var selectedFriend: Friend = Friend()
    
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    var nameref: DatabaseReference!
    var storageRef: StorageReference!
    
    var friendsRef: DatabaseReference!
    var friendPlacesRef: DatabaseReference!
        
    func listen () {
        self.selectedPlace = ""
        self.comments = ""
        self.image = nil
        self.uiImage = nil
        
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user.uid)")
                self.ref = Database.database().reference().child("users").child(user.uid)
                self.nameref = Database.database().reference().child("names")
                self.storageRef = Storage.storage().reference().child("users").child(user.uid)
                self.friendsRef = Database.database().reference().child("favourites").child(user.uid)
                
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
                self.userId = user.uid
                self.getPlaces()
                self.getName()
                self.getFriends()
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func setUserName(){
        if (session != nil){
            self.listen()
            self.nameref.child(self.userId).setValue(self.userName)
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut () {
        do {
            try Auth.auth().signOut()
            self.session = nil
//            return true
        } catch {
//            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func getPlaces(){
        ref.observe(DataEventType.value){ (snapshot) in
            self.items = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                let savedPlace = SavedPlace(snapshot: snapshot){
                    self.items.append(savedPlace)
                }
            }
        }
    }
    
    func getName(){
        let userID = Auth.auth().currentUser?.uid
        nameref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.userName = snapshot.value as? String ?? ""
            print("Username: " + self.userName)
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getFriends(){
        friendsRef.observe(DataEventType.value){ (snapshot) in
            self.friends = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                let friend = Friend(snapshot: snapshot){
                    self.friends.append(friend)
                }
            }
        }
    }
    
    func getFriendPlaces(){
        self.friendPlacesRef = Database.database().reference().child("users").child(self.selectedFriend.favId)

        friendPlacesRef.observe(DataEventType.value){ (snapshot) in
            self.friendItems = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                let savedPlace = SavedPlace(snapshot: snapshot){
                    self.friendItems.append(savedPlace)
                }
            }
        }
    }
}

class User {
    var uid: String
    var email: String?
    var displayName: String?

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}
