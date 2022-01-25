//
//  liForgotPasswordView.swift
//  fall-detector
//
//  Created by Harry Wixley on 24/01/2022.
//

import SwiftUI

struct liForgotPasswordView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    @State private var showErr: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    if appState.inappState.taskSuccess == nil || !appState.inappState.taskSuccess! {
                        Form {
                            Section(header: Text("Account Details")) {
                                Textfield(title: "Email", contentType: UITextContentType.emailAddress, keyboardType: UIKeyboardType.emailAddress, labelWidth: 90, output: $email)
                                if showErr {
                                    if appState.inappState.taskSuccess == nil {
                                        Warning(text: "Please enter a valid email address")
                                    } else {
                                        Warning(text: "Error: for some reason we are unable to send a password reset link to your email. Please check your internet connection and try again.")
                                    }
                                }
                            }
                        }
                    } else {
                        Text("A password reset link has been sent to your email \(email). You must open it to reset your password!")
                            .padding(.all, 10)
                    }
                    
                    Button(action: {
                        appState.inappState.showSpinner = true
                        
                        if isValidEmail(email) {
                            showErr = false
                            resetPassword(email: email) { success in
                                if success {
                                    appState.inappState.taskSuccess = true
                                } else {
                                    appState.inappState.taskSuccess = false
                                    showErr = true
                                }
                            }
                        } else {
                            showErr = true
                        }
                        appState.inappState.showSpinner = false
                    }) {
                        if appState.inappState.showSpinner {
                            ProgressView()
                        } else {
                            MainButton(title: "Reset Password", image: "")
                        }
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                    .isHidden(appState.inappState.taskSuccess ?? false)
                    
                    Spacer()
                }
                .modifier(NavigationBarStyle(title: "Reset Password", page: .login, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: .login))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            appState.inappState.taskSuccess = nil
        }
    }
}

struct liForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        liForgotPasswordView()
    }
}
