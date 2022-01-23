//
//  RegisterView.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    
    @State var name: String = ""
    @State var yob = 0
    @State var height: String = ""
    @State var weight: String = ""
    @State var is_female = 0
    @State var phone: String = ""
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    if appState.inappState.regSection == 0 {
                        Form {
                            Section(header: Text("About You")) {
                                Textfield(title: "*Name", contentType: UITextContentType.name, keyboardType: UIKeyboardType.asciiCapable, labelWidth: 90, output: $name)
                                HStack(spacing: 10) {
                                    Text("*Year of Birth")
                                        .modifier(LabelText())
                                        .frame(width: 90, alignment: .trailing)
                                    Picker(selection: $yob, label: Text("")) {
                                        ForEach(0..<MyData.years.count) { idx in
                                            Text(String(MyData.years[idx])).tag(idx)
                                        }
                                    }
                                    .tint(MyColours.p0)
                                }
                                Textfield(title: "*Height", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, output: $height)
                                Textfield(title: "*Weight", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, output: $weight)
                                HStack(spacing: 0) {
                                    Text("*Gender")
                                        .modifier(LabelText())
                                        .frame(width: 90, alignment: .trailing)
                                    Picker("*Gender", selection: $is_female) {
                                        Text("Male")
                                            .modifier(LabelText())
                                            .tag(0)
                                        Text("Female")
                                            .modifier(LabelText())
                                            .tag(1)
                                    }
                                    .frame(height: 30)
                                    .modifier(HPadding(pad: 10))
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                            }
                        }
                            
                        Button(action: {
                            if name != "" && height != "" && weight != "" {
                                appState.inappState.regSection = 1
                            }
                        }) {
                            MainButton(title: "Next", image: "")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                    } else {
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
                            })
                        }
                        
                        Button(action: {
                            if isValidEmail(email) && password1 == password2 && isValidPass(password1) {
                                let user = User(id: "", name: name, email: email, password: password1, phone: phone, yob: yob, height: Int(height)!, weight: Int(weight)!, is_female: is_female == 0 ? false : true, medical_conditions: "", contacts: [])
                                
                                createAccount(user: user, completion: { success in
                                    if success {
                                        appState.inappState.page = .main
                                    }
                                })
                            }
                        }) {
                            MainButton(title: "Register", image: "")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                    }
                }
                .modifier(NavigationBarStyle(title: "Register", page: .entry, hideBackButton: false, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: appState.inappState.regSection == 0 ? .entry : .register))
        }
        .onDisappear {
            appState.inappState.regSection = 0
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
