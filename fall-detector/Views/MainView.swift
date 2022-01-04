//
//  MainView.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    @State var selectedTab = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(MyColours.b2)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(appState)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                        .scaleEffect(selectedTab == 0 ? 1.05 : 1)
                }
            
            StatsView()
                .environmentObject(appState)
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                        .scaleEffect(selectedTab == 1 ? 1.05 : 1)
                }
            
            MenuView()
                .environmentObject(appState)
                .tabItem {
                    Label("Menu", systemImage: "line.3.horizontal")
                        .scaleEffect(selectedTab == 2 ? 1.05 : 1)
                }
        }
        .accentColor(MyColours.p0)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
