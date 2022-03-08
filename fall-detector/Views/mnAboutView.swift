//
//  mnAboutView.swift
//  fall-detector
//
//  Created by Harry Wixley on 06/01/2022.
//

import SwiftUI

struct mnAboutView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {
                    Text("Smart wearable sensors for fall detection.\n\nSoftware developed entirely by Harry Wixley (UG4 AI & Computer Science student at the University of Edinburgh) for his UG4 Honours Project.")
                        .modifier(DefaultText(size: 20))
                }
                .modifier(VPadding(pad: 8))
                .modifier(HPadding(pad: 8))
                .modifier(NavigationBarStyle(title: "About", page: .main, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: .main))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct mnAboutView_Previews: PreviewProvider {
    static var previews: some View {
        mnAboutView()
    }
}
