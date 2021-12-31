//
//  LoginView.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Email")
                        .modifier(SubtitleText())
                    Text("Password")
                        .modifier(SubtitleText())
                }
                //.modifier(Class)
                
                VStack {
                    TextField("Email", text: $email)
                        .modifier(ClassicTextfield())
                    TextField("Password", text: $password)
                        .modifier(ClassicTextfield())
                }
            }
            .padding()
            
            Button(action: {
                
            }) {
                HStack {
                    Text("Login")
                        .modifier(ClassicButtonText())
                }
            }
            .buttonStyle(ClassicButtonStyle())
        }
        //.modifier(BackgroundStack())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
