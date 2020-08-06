//
//  SignInView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/3/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false

    @EnvironmentObject var session: SessionStore

    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }

    var body: some View {
        NavigationView{
            if (session.session != nil) {
                VStack{
                    Spacer()
                    Text("Username: " + session.userName)
                    Text("User Id: " + session.userId)
                    Spacer()
                    Button(action: session.signOut){
                        Text("Sign out")
                    }
                    Spacer()
                }
            } else {
                VStack {
                    Spacer()
                    TextField("Email Address", text: $email)
                    SecureField("Password", text: $password)
                    if (error) {
                        Text("password incorrect or no network connection")
                    }
                    Spacer()
                    Button(action: signIn) {
                        Text("Sign in")
                    }
                    
                    Text("Sign in to sync across devices, store images and much more!")
                        .font(.headline)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
        .environmentObject(SessionStore())
    }
}
