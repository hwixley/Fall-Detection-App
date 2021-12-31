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
                    .padding()
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Text("Using movement and heart rate data")
                    .padding()
                    .foregroundColor(.white)
                    .font(.subheadline)
                
                Divider()
                Spacer()
            }
            .background(.black)
            
            VStack {
                Spacer()
                
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Log in")
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 350, height: 60)
                    }
                }
                .background(.blue)
                .cornerRadius(20)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Register")
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 350, height: 60)
                    }
                }
                .background(.blue)
                .cornerRadius(20)
                
                Divider()
                Spacer()
            }
            .background(.black)
            .frame(width: 400, height: 200, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
