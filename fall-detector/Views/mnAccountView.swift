//
//  mnAccountView.swift
//  fall-detector
//
//  Created by Harry Wixley on 06/01/2022.
//

import SwiftUI

struct mnAccountView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {
                    if self.appState.inappState.user != nil {
                        Text("Personal Information:")
                        
                        Divider()
                        
                        Text("Name: \(appState.inappState.user!.name)")
                        Text("Phone number: \(appState.inappState.user!.phone)")
                        Text("Email: \(appState.inappState.user!.email)")
                        
                        Divider()
                        
                        Text("Emergency Contacts:")
                        
                        Divider()
                        
                        let numContacts = appState.inappState.user!.contacts.count
                        ForEach(0..<numContacts) { i in
                            let contact = appState.inappState.user!.contacts[i]
                            
                            Divider()
                            
                            Text("Contact \(i+1):")
                            
                            Divider()
                            
                            Text("Name: \(contact.name)")
                            Text("Phone number: \(contact.phone)")
                            Text("Email: \(contact.email)")
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
