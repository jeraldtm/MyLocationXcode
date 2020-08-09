//
//  SignUpView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 8/7/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUpView : View {
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @State var userName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false

    @EnvironmentObject var session: SessionStore

    func signUp () {
        loading = true
        error = false
        
        session.signUp(email: email, password: password) { (result, error) in
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
        VStack {
            Spacer()
            Text("Create Account")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Spacer()
//            TextField("Name", text: $userName)
            HStack {
                Spacer()
                TextField("Email Address", text: $email)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            HStack {
                Spacer()
                TextField("Password", text: $password)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            if (error) {
                Text("password incorrect or no network connection")
            }
            Spacer()
            Button(action: {
                self.signUp()
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Sign up")
            }
                .font(.headline)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        return SignUpView()
        .environmentObject(SessionStore())
    }
}
