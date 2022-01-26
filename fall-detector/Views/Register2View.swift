//
//  Register2View.swift
//  fall-detector
//
//  Created by Harry Wixley on 26/01/2022.
//

import SwiftUI

struct Register2View: View {
    @EnvironmentObject var appState: AppState
    
    @State var phone: String = ""
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    @State var showErr = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        Section(header: Text("Account Details"), content: {
                            Textfield(title: "*Phone", contentType: UITextContentType.telephoneNumber, keyboardType: UIKeyboardType.phonePad, labelWidth: 90, output: $phone)
                            Textfield(title: "*Email", contentType: UITextContentType.emailAddress, keyboardType: UIKeyboardType.emailAddress, labelWidth: 90, output: $email)
                            
                            HStack(spacing:10) {
                                VStack(spacing: 40) {
                                    Text("●")
                                        .foregroundColor(password1 == "" ? .white : isValidPass(password1) && password1 == password2 ? .green : isValidPass(password1) ? .orange : .red)
                                    Text("●")
                                        .foregroundColor(password2 == "" ? .white : isValidPass(password1) && password1 == password2 ? .green : isValidPass(password2) ? .orange : .red)
                                }
                                .padding(.leading, 10)
                                VStack(spacing: 20) {
                                    SecureTextfield(title: "*Password", labelWidth: 90, output: $password1)
                                    SecureTextfield(title: "*Re-enter Password", labelWidth: 90, output: $password2)
                                }
                            }
                            
                            if showErr {
                                Warning(text: "Please fill in all the required fields")
                            }
                        })
                        .onDisappear {
                            showErr = false
                        }
                        
                        if appState.inappState.showSpinner {
                            ProgressView()
                        }
                    }
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        appState.inappState.showSpinner = true
                        
                        if isValidEmail(email) && password1 == password2 && isValidPass(password1) {
                            showErr = false
                            MyData.user!.email = email
                            MyData.user!.phone = phone
                            MyData.user!.password = password1
                            
                            createAccount(user: MyData.user!, completion: { success in
                                if success {
                                    appState.inappState.showSpinner = false
                                    appState.inappState.page = .main
                                } else {
                                    showErr = true
                                }
                            })
                        } else {
                            showErr = true
                        }
                        appState.inappState.showSpinner = false
                    }) {
                        MainButton(title: "Register", image: "")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                    .isHidden(appState.inappState.showSpinner)
                }
                .modifier(NavigationBarStyle(title: "Register", page: .register1, hideBackButton: false, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: .register1))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Register2View_Previews: PreviewProvider {
    static var previews: some View {
        Register2View()
    }
}
