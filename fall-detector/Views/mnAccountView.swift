//
//  mnAccountView.swift
//  fall-detector
//
//  Created by Harry Wixley on 06/01/2022.
//

import SwiftUI

struct mnAccountView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var isEditing = false
    
    @State var name: String = ""
    @State var yob = MyData.years.firstIndex(of: MyData.user!.yob)!
    @State var height: String = ""
    @State var weight: String = ""
    @State var is_female = MyData.user!.is_female ? 1 : 0
    @State var phone: String = ""
    @State var email: String = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    if MyData.user != nil {
                        Form {
                            Section("Account Information") {
                                if !isEditing {
                                    CustLabel(title: "Name:", value: MyData.user!.name)
                                    CustLabel(title: "Phone:", value: MyData.user!.phone)
                                    CustLabel(title: "Email:", value: MyData.user!.email)
                                } else {
                                    Textfield(title: "Name", contentType: UITextContentType.name, keyboardType: UIKeyboardType.asciiCapable, labelWidth: 90, placeholder: MyData.user!.name, output: $name)
                                    Textfield(title: "Phone", contentType: UITextContentType.telephoneNumber, keyboardType: UIKeyboardType.phonePad, labelWidth: 90, placeholder: MyData.user!.phone, output: $phone)
                                    Textfield(title: "Email", contentType: UITextContentType.emailAddress, keyboardType: UIKeyboardType.emailAddress, labelWidth: 90, placeholder: MyData.user!.email, output: $email)
                                }
                            }
                            Section("Biometric Data") {
                                if !isEditing {
                                    CustLabel(title: "Gender:", value: MyData.user!.is_female ? "Female" : "Male")
                                    CustLabel(title: "Year of Birth:", value: String(MyData.user!.yob))
                                    CustLabel(title: "Height (cm):", value: String(MyData.user!.height))
                                    CustLabel(title: "Weight (kg):", value: String(MyData.user!.weight))
                                } else {
                                    HStack(spacing: 0) {
                                        Text("Gender")
                                            .modifier(LabelText())
                                            .frame(width: 90, alignment: .trailing)
                                        Picker("Gender", selection: $is_female) {
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
                                    HStack(spacing: 10) {
                                        Text("Year of Birth")
                                            .modifier(LabelText())
                                            .frame(width: 90, alignment: .trailing)
                                        Picker(selection: $yob, label: Text("")) {
                                            ForEach(0..<MyData.years.count) { idx in
                                                Text(String(MyData.years[idx])).tag(idx)
                                            }
                                        }
                                        .tint(MyColours.p0)
                                    }
                                    Textfield(title: "Height (cm)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, placeholder: String(MyData.user!.height), output: $height)
                                    Textfield(title: "Weight (kg)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, placeholder: String(MyData.user!.weight), output: $weight)
                                }
                            }
                            Section("Emergency Contacts") {
                                if !isEditing {
                                    let numContacts = MyData.user!.contacts.count
                                    
                                    if numContacts > 0 {
                                        ForEach(0..<numContacts) { i in
                                            let contact = MyData.user!.contacts[i]
                                            
                                            Divider()
                                            
                                            Text("Contact \(i+1):")
                                            
                                            Divider()
                                            
                                            CustLabel(title: "Name:", value: contact.name)
                                            CustLabel(title: "Phone:", value: contact.phone)
                                            CustLabel(title: "Email:", value: contact.email)
                                        }
                                    } else {
                                        Warning(text: "You have no emergency contacts! Please add some so we can contact someone if you fall over")
                                    }
                                } else {
                                    
                                }
                            }
                        }
                        
                        if !isEditing {
                            Button(action: {
                                isEditing = true
                            }) {
                                MainButton(title: "Edit", image: "pencil")
                            }
                            .buttonStyle(ClassicButtonStyle(useGradient: true))
                        } else {
                            Button(action: {
                                
                            }) {
                                MainButton(title: "Save Changes", image: "checkmark")
                            }
                            .buttonStyle(ClassicButtonStyle(useGradient: true))
                            
                            Button(action: {
                                isEditing = false
                                name = ""
                                
                            }) {
                                MainButton(title: "Cancel", image: "trash")
                            }
                            .buttonStyle(ClassicButtonStyle(useGradient: true))
                        }
                    }
                }
                .modifier(NavigationBarStyle(title: "Account", page: .main, hideBackButton: false, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: .main))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct mnAccountView_Previews: PreviewProvider {
    static var previews: some View {
        mnAccountView()
    }
}
