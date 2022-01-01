//
//  EntryView.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var appState: AppState
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont(name: fontfamily, size: 30)!]
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont(name: fontfamily, size: 30)!]
        UINavigationBar.appearance().barTintColor = UIColor.blue
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Fall Detection System")
                    .modifier(TitleText())
                
                //Text("Using movement and heart rate data")
                //    .modifier(SubtitleText())
            }
            .frame(width: UIScreen.screenWidth - 20, height: 300, alignment: .center)

            VStack(spacing: 20) {
                Button(action: {
                    appState.inappState = .login
                }, label: {
                    MainButton(title: "Log in")
                })
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                
                Button(action: {
                    appState.inappState = .register
                }, label: {
                    MainButton(title: "Register")
                })
                    .buttonStyle(ClassicButtonStyle(useGradient: false))
                 
            }
            .frame(width: UIScreen.screenWidth, height: 200, alignment: .center)
        }
        .modifier(FullBackgroundStack())
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
