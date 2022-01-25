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
    
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    
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
                                    //Label
                                }
                            }
                            Section("Biometric Data") {
                                if !isEditing {
                                    CustLabel(title: "Year of Birth:", value: String(MyData.user!.yob))
                                    CustLabel(title: "Height (cm):", value: String(MyData.user!.height))
                                    CustLabel(title: "Weight (kg):", value: String(MyData.user!.weight))
                                } else {
                                    
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
                                MainButton(title: "Edit", image: "")
                            }
                            .buttonStyle(ClassicButtonStyle(useGradient: true))
                        } else {
                            Button(action: {
                                
                            }) {
                                MainButton(title: "Save Changes", image: "")
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
