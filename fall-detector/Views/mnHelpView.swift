//
//  mnHelpView.swift
//  fall-detector
//
//  Created by Harry Wixley on 06/01/2022.
//

import SwiftUI

struct mnHelpView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack(spacing:40) {
                    Text("Please talk to Harry Wixley if you need help with anything.\n\nEmail: hwixley1@gmail.com\nPhone: +44 07484111141")
                        .modifier(DefaultText(size: 20))
                }
                .modifier(VPadding(pad: 8))
                .modifier(HPadding(pad: 6))
                .modifier(NavigationBarStyle(title: "Help", page: .main, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: .main))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct mnHelpView_Previews: PreviewProvider {
    static var previews: some View {
        mnHelpView()
    }
}
