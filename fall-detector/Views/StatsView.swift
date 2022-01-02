//
//  StatsView.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/01/2022.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {

                }
                .modifier(NavigationBarStyle(title: "Stats", inappState: .entry, hideBackButton: true, appState: appState))
            }
            .modifier(BackgroundStack())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
