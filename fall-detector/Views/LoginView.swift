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
    @State private var showErr: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        Section(header: Text("Account Details")) {
                            Textfield(title: "Email", contentType: UITextContentType.emailAddress, keyboardType: UIKeyboardType.emailAddress, labelWidth: 90, output: $email)
                            SecureTextfield(title: "Password", labelWidth: 90, output: $password)
                            if showErr {
                                Warning(text: "Sorry we could not seem to find an account with that email and password. Please try again.")
                            }
                        }
                    }
                    
                    Button(action: {
                        if isValidEmail(email) && isValidPass(password) {
                            showErr = false
                            loginUser(email: email, password: password) { success in
                                if success {
                                    appState.inappState.page = .main
                                } else {
                                    showErr = true
                                }
                            }
                        } else {
                            showErr = true
                        }
                    }) {
                        MainButton(title: "Log in", image: "")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                    
                    Button(action: {
                        appState.inappState.page = .resetpass
                    }) {
                        SubButton(title: "I forgot my password")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                    
                    Spacer()
                }
                .modifier(NavigationBarStyle(title: "Log in", page: .entry, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: .entry))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            appState.inappState.showSpinner = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
