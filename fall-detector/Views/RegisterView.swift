//
//  RegisterView.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {
                    HStack(spacing:10) {
                        VStack(spacing: 50) {
                            Text("")
                            Text("●")
                                .foregroundColor(password1 != password2 ? .red : password1 == "" ? .white : NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[0-9]).{8,}$").evaluate(with: password1) ? .green : .red)
                            Text("●")
                                .foregroundColor(password1 != password2 ? .red : password1 == "" ? .white : NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[0-9]).{8,}$").evaluate(with: password1) ? .green : .red)
                        }
                        .padding(.leading, 10)
                        
                        VStack {
                            Textfield(title: "Email", contentType: UITextContentType.emailAddress, keyboardType: UIKeyboardType.emailAddress, labelWidth: 90, output: $email)
                            SecureTextfield(title: "Password", labelWidth: 90, output: $password1)
                            SecureTextfield(title: "Re-enter Password", labelWidth: 90, output: $password2)
                        }
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        if password1 == password2 && NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[0-9]).{8,}$").evaluate(with: password1) {
                            appState.inappState = .home
                        }
                    }) {
                        MainButton(title: "Register")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                }
                .modifier(NavigationBarStyle(title: "Register", inappState: .entry, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
