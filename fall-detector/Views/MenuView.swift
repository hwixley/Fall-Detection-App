//
//  MenuView.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/01/2022.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Button {
                        self.appState.inappState.tab = 2
                        self.appState.inappState.page = .account
                    } label: {
                        MainButton(title: "Account", image: "person.crop.circle")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        self.appState.inappState.tab = 2
                        self.appState.inappState.page = .about
                    } label: {
                        MainButton(title: "About", image: "info.circle")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        self.appState.inappState.tab = 2
                        self.appState.inappState.page = .help
                    } label: {
                        MainButton(title: "Help", image: "questionmark.circle")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        self.appState.inappState.tab = 2
                        self.appState.inappState.page = .settings
                    } label: {
                        MainButton(title: "Settings", image: "gear")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        showLogoutAlert = true
                    } label: {
                        MainButton(title: "Log Out", image: "figure.walk")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    .alert("Are you sure you want to log out?", isPresented: $showLogoutAlert) {
                        Button("Yes", role: .destructive) {
                            self.appState.inappState = InAppState()
                        }
                        .modifier(ClassicButtonText())
                        Button("No, cancel", role: .cancel) {
                            showLogoutAlert = false
                        }
                        .modifier(ClassicButtonText())
                    }
                }
                .accentColor(MyColours.p0)
                .modifier(NavigationBarStyle(title: "Menu", page: .entry, hideBackButton: true, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: nil))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
