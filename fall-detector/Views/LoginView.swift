//
//  LoginView.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var pressedBack: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {
                    VStack {
                        Textfield(title: "Email", contentType: UITextContentType.emailAddress, keyboardType: UIKeyboardType.emailAddress, labelWidth: 90, output: $email)
                        SecureTextfield(title: "Password", labelWidth: 90, output: $password)
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            
                        }) {
                            MainButton(title: "Log in")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                        
                        Button(action: {
                            
                        }) {
                            SubButton(title: "I forgot my password")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                    }
                }
                .modifier(NavigationBarStyle(title: "Log in", onboardingState: .entry, appState: appState))
                

            }
            .modifier(BackgroundStack())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
