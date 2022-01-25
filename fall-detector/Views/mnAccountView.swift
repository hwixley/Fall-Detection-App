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
    @State var contacts = MyData.user!.contacts
    @State var newContactName = ""
    @State var newContactPhone = ""
    @State var showAddErr = false
    
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
                                    Textfield(title: "Name", contentType: UITextContentType.name, keyboardType: UIKeyboardType.asciiCapable, labelWidth: 55, placeholder: MyData.user!.name, output: $name)
                                    Textfield(title: "Phone", contentType: UITextContentType.telephoneNumber, keyboardType: UIKeyboardType.phonePad, labelWidth: 55, placeholder: MyData.user!.phone, output: $phone)
                                    CustLabel(title: "Email", value: MyData.user!.email)
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
                                            .frame(width: 70, alignment: .trailing)
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
                                            .frame(width: 70, alignment: .trailing)
                                        Picker(selection: $yob, label: Text("")) {
                                            ForEach(0..<MyData.years.count) { idx in
                                                Text(String(MyData.years[idx])).tag(idx)
                                            }
                                        }
                                        .tint(MyColours.p0)
                                    }
                                    Textfield(title: "Height (cm)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 70, placeholder: String(MyData.user!.height), output: $height)
                                    Textfield(title: "Weight (kg)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 70, placeholder: String(MyData.user!.weight), output: $weight)
                                }
                            }
                            Section("Emergency Contacts") {
                                if !isEditing {
                                    if contacts.count > 0 {
                                        List {
                                            ForEach(contacts, id: \.self) { contact in
                                                ContactView(contact: contact)
                                            }
                                        }
                                    } else {
                                        Warning(text: "You have no emergency contacts! Please add some so we can contact someone if you fall over")
                                    }
                                } else {
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
                            }
                            if isEditing {
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
                                var fields : [AnyHashable : Any] = [:]
                                var userCopy = MyData.user!
                                
                                if name != "" {
                                    fields["name"] = name
                                    userCopy.name = name
                                }
                                if phone != "" {
                                    fields["phone"] = phone
                                    userCopy.phone = phone
                                }
                                if yob != MyData.years.firstIndex(of: MyData.user!.yob)! {
                                    fields["yob"] = MyData.years[yob]
                                    userCopy.yob = MyData.years[yob]
                                }
                                if is_female != (MyData.user!.is_female ? 1 : 0) {
                                    fields["is_female"] = is_female == 1 ? true : false
                                    userCopy.is_female = is_female == 1 ? true : false
                                }
                                if height != "" {
                                    fields["height"] = Int(height)!
                                    userCopy.height = Int(height)!
                                }
                                if weight != "" {
                                    fields["weight"] = Int(weight)!
                                    userCopy.weight = Int(weight)!
                                }
                                if contacts != MyData.user!.contacts {
                                    userCopy.contacts = contacts
                                }
                                
                                updateUser(updatedFields: fields) { success in
                                    if success {
                                        MyData.user = userCopy
                                        exitEditing()
                                    }
                                }
                            }) {
                                MainButton(title: "Save Changes", image: "checkmark")
                            }
                            .buttonStyle(ClassicButtonStyle(useGradient: true))
                            
                            Button(action: {
                                exitEditing()
                            }) {
                                MainButton(title: "Cancel", image: "trash")
                            }
                            .buttonStyle(ClassicButtonStyle(useGradient: true))
                        }
                    }
                }
                .modifier(NavigationBarStyle(title: isEditing ? "Edit Account" : "Account", page: .main, hideBackButton: isEditing ? true : false, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: .main))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func exitEditing() {
        isEditing = false
        name = ""
        yob = MyData.years.firstIndex(of: MyData.user!.yob)!
        height = ""
        weight = ""
        is_female = MyData.user!.is_female ? 1 : 0
        phone = ""
        contacts = MyData.user!.contacts
    }
    
    private func deleteContacts(offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

struct mnAccountView_Previews: PreviewProvider {
    static var previews: some View {
        mnAccountView()
    }
}
