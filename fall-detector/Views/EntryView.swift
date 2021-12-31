//
//  ContentView.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Fall Detection System")
                    .modifier(TitleText())
                
                Text("Using movement and heart rate data")
                    .modifier(SubtitleText())
            }
            .background(.black)
            .frame(width: UIScreen.screenWidth, height: 300, alignment: .center)

            VStack(spacing: 20) {
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Log in")
                            .modifier(ClassicButtonText())
                    }
                }
                .buttonStyle(ClassicButtonStyle())
                
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Register")
                            .modifier(ClassicButtonText())
                    }
                }
                .buttonStyle(ClassicButtonStyle())
            }
            .background(.black)
            .frame(width: UIScreen.screenWidth, height: 200, alignment: .center)
        }
        .modifier(BackgroundStack())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
