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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {
                    if MyData.user != nil {
                        Form {
                            Section("Account Information") {
                                CustLabel(title: "Name:", value: MyData.user!.name)
                                CustLabel(title: "Phone:", value: MyData.user!.phone)
                                CustLabel(title: "Email:", value: MyData.user!.email)
                            }
                            Section("Emergency Contacts") {
                                let numContacts = MyData.user!.contacts.count
                                ForEach(0..<numContacts) { i in
                                    let contact = MyData.user!.contacts[i]
                                    
                                    Divider()
                                    
                                    Text("Contact \(i+1):")
                                    
                                    Divider()
                                    
                                    CustLabel(title: "Name:", value: contact.name)
                                    CustLabel(title: "Phone:", value: contact.phone)
                                    CustLabel(title: "Email:", value: contact.email)
                                }
                            }
                        }
                    }
                }
                .modifier(NavigationBarStyle(title: "Account", page: .main, hideBackButton: false, appState: appState))
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
