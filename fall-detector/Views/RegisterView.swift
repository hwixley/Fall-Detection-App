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
    @State var showErr = false
    @State var contacts: [Person] = []
    @State var newContactName = ""
    @State var newContactPhone = ""
    @State var showAddErr = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        if appState.inappState.regSection == 0 {
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
                                Textfield(title: "*Height (cm)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, output: $height)
                                Textfield(title: "*Weight (kg)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, output: $weight)
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
                                
                                if showErr {
                                    Warning(text: "Please fill in all the required fields")
                                }
                            }
                        } else if appState.inappState.regSection == 1 {
                            Section("Emergency Contacts") {
                                if contacts.count > 0 {
                                    List {
                                        ForEach(contacts, id: \.self) { contact in
                                            ContactView(contact: contact)
                                        }
                                        .onDelete(perform: deleteContacts)
                                    }
                                } else {
                                    Warning(text: "You have no emergency contacts! Please add some so we can contact someone if you fall over")
                                }
                            }
                            Section("Add new contact") {
                                Textfield(title: "Name", contentType: UITextContentType.name, keyboardType: UIKeyboardType.asciiCapable, labelWidth: 70, output: $newContactName)
                                Textfield(title: "Phone", contentType: UITextContentType.telephoneNumber, keyboardType: UIKeyboardType.numberPad, labelWidth: 70, output: $newContactPhone)
                                
                                if showAddErr {
                                    Warning(text: "You must fill in both fields to add a contact")
                                }
                                
                                Button(action: {
                                    if newContactName != "" && newContactPhone != "" {
                                        contacts.append(Person(id: "", name: newContactName, email: "", phone: newContactPhone))
                                        newContactName = ""
                                        newContactPhone = ""
                                    } else {
                                        showAddErr = true
                                    }
                                }) {
                                    MainButton(title: "Add Contact", image: "phone.fill.badge.plus", color: MyColours.p0)
                                }
                                .buttonStyle(ClassicButtonStyle(useGradient: false))
                            }
                        } else {
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
                    }
                    if appState.inappState.regSection == 0 {
                        Button(action: {
                            if name != "" && height != "" && weight != "" {
                                showErr = false
                                appState.inappState.regSection = 1
                            } else {
                                showErr = true
                            }
                        }) {
                            MainButton(title: "Next", image: "")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                        
                    } else if appState.inappState.regSection == 1 {
                        Button(action: {
                            showErr = false
                            appState.inappState.regSection = 2
                        }) {
                            MainButton(title: "Next", image: "")
                        }
                        .buttonStyle(ClassicButtonStyle(useGradient: true))
                        
                    } else {
                        Button(action: {
                            appState.inappState.showSpinner = true
                            
                            if isValidEmail(email) && password1 == password2 && isValidPass(password1) {
                                showErr = false
                                let user = User(id: "", name: name, email: email, password: password1, phone: phone, yob: MyData.years[yob], height: Int(height)!, weight: Int(weight)!, is_female: is_female == 0 ? false : true, medical_conditions: "", contacts: contacts)
                                
                                createAccount(user: user, completion: { success in
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
    
    private func deleteContacts(offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
