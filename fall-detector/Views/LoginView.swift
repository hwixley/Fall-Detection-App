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
        NavigationView {
            VStack {
                HStack(spacing: 10) {
                    VStack(spacing: 6) {
                        
                        Spacer()
                        
                        Text("Email")
                            .modifier(LabelText())
                            .frame(width: 90, alignment: .trailing)
                        
                        Spacer()
                        
                        Text("Password")
                            .modifier(LabelText())
                            .frame(width: 90, alignment: .trailing)
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 10) {
                        TextField("Enter your email...", text: $email)
                            .modifier(PlaceholderStyle(input: email, placeholder: "Enter your email..."))
                        
                        TextField("Enter your password...", text: $password)
                            .modifier(PlaceholderStyle(input: password, placeholder: "Enter your password..."))
                    }
                }
                .padding()
                .frame(height: 100)
                
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Login")
                            .modifier(ClassicButtonText())
                    }
                }
                .buttonStyle(ClassicButtonStyle())
                
                Button(action: {
                    
                }) {
                    HStack {
                        Text("I forgot my password")
                            .modifier(ClassicButtonText())
                    }
                }
                .buttonStyle(ClassicButtonStyle())
            }
            .modifier(BackgroundStack())
            .modifier(NavigationBarStyle(title: "Login"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
