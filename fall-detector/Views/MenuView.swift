//
//  MenuView.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/01/2022.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Button {
                        //
                    } label: {
                        MainButton(title: "Account", image: "person.crop.circle")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        //
                    } label: {
                        MainButton(title: "About", image: "info.circle")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        //
                    } label: {
                        MainButton(title: "Help", image: "questionmark.circle")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        //
                    } label: {
                        MainButton(title: "Settings", image: "gear")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                    
                    Button {
                        //
                    } label: {
                        MainButton(title: "Log Out", image: "figure.walk")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                }
                .accentColor(MyColours.p0)
                .modifier(NavigationBarStyle(title: "Menu", page: .entry, hideBackButton: true, appState: appState))
            }
            .modifier(BackgroundStack())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
