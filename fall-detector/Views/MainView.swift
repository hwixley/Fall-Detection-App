//
//  MainView.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    //@EnvironmentObject var polarManager: PolarBleSdkManager
    //@EnvironmentObject var coremotionData: CoreMotionData
    @EnvironmentObject var dataWrangler: DataWrangler
    @EnvironmentObject var mlModel: CustomMLModel
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(MyColours.b2)
    }
    
    var body: some View {
        TabView(selection: $appState.inappState.tab) {
            HomeView()
                .environmentObject(appState)
                .environmentObject(dataWrangler)
                .environmentObject(mlModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                        .scaleEffect(self.appState.inappState.tab == 0 ? 1.05 : 1)
                }
                .tag(0)
            
            StatsView()
                .environmentObject(appState)
                .environmentObject(dataWrangler)
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                        .scaleEffect(self.appState.inappState.tab == 1 ? 1.05 : 1)
                }
                .tag(1)
            
            MenuView()
                .environmentObject(appState)
                .tabItem {
                    
                    Label("Menu", systemImage: "line.3.horizontal")
                        .scaleEffect(self.appState.inappState.tab == 2 ? 1.05 : 1)
                }
                .tag(2)
        }
        .accentColor(MyColours.p0)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
