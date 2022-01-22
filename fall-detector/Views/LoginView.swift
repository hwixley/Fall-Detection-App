//
//  LoginView.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                            if isValidEmail(email) && isValidPass(password) {
                                Auth.auth().signIn(withEmail: email, password: password) { authDataResult, err in
                                    if err != nil {
                                        return
                                    } else if authDataResult != nil {
                                        MyData.user = initUser(authDataResult: authDataResult!)
                                        if MyData.user != nil {
                                            appState.inappState.page = .main
                                        }
                                    }
                                }
                            }
                        }) {
                            MainButton(title: "Log in", image: "")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                        
                        Button(action: {
                            
                        }) {
                            SubButton(title: "I forgot my password")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                    }
                }
                .modifier(NavigationBarStyle(title: "Log in", page: .entry, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: .entry))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
