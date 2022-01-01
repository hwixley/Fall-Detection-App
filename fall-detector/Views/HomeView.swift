//
//  TabView.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView {
            NavigationView {
                ZStack(alignment: .top) {
                    MyColours.b1.edgesIgnoringSafeArea(.all)
                    VStack(spacing:40) {

                    }
                    .modifier(NavigationBarStyle(title: "Home", inappState: .entry, hideBackButton: true, appState: appState))
                }
                .modifier(BackgroundStack())
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Home", systemImage: "home")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
