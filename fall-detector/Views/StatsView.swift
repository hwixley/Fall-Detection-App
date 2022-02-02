//
//  StatsView.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/01/2022.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var polarManager: PolarBleSdkManager
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {

                }
                .modifier(NavigationBarStyle(title: "Stats", page: .entry, hideBackButton: true, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: nil))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
