//
//  Register1View.swift
//  fall-detector
//
//  Created by Harry Wixley on 26/01/2022.
//

import SwiftUI

struct Register1View: View {
    @EnvironmentObject var appState: AppState
    
    @State var contacts: [Person] = MyData.user!.contacts
    @State var newContactName = ""
    @State var newContactPhone = ""
    @State var showAddErr = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
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
                                    contacts.append(Person(id: NSUUID().uuidString, name: newContactName, phone: newContactPhone, isOnFirebase: false))
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
                    }
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        MyData.user!.contacts = contacts
                        appState.inappState.page = .register2
                    }) {
                        MainButton(title: "Next", image: "")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                }
                .modifier(NavigationBarStyle(title: "Register", page: .register, hideBackButton: false, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: .register))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteContacts(offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

struct Register1View_Previews: PreviewProvider {
    static var previews: some View {
        Register1View()
    }
}
