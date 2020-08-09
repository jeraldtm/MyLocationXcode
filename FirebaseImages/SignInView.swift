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
                    Text("User Id:")
                    Text(session.userId)
                    Spacer()
                    Button(action: session.signOut){
                        Text("Sign out")
                    }
                    Spacer()
                }
            } else {
                VStack {
                    Spacer()
                    Text("Sign in")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    Spacer()
                    
                    HStack {
                        Spacer()
                        TextField("Email Address", text: $email)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        SecureField("Password", text: $password)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    if (error) {
                        Text("password incorrect or no network connection")
                    }
                    Spacer()
                    HStack{
//                        Button(action: signIn) {
//                            Text("Set Name")
//                        }
                        
                        Button(action: signIn) {
                            Text("Sign in")
                        }
                    }
                    
                    Group{
                        Spacer()
                        NavigationLink(destination: SignUpView()){
                            Text("Sign up to sync across devices, store images and much more!")
                        }
                            .font(.headline)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
        .environmentObject(SessionStore())
    }
}
