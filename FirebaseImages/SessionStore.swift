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
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user.uid)")
                self.ref = Database.database().reference().child("users").child(user.uid)
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
                self.userId = user.uid
                self.getPlaces()
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
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
