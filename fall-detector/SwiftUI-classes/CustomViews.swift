//
//  CustomViews.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import Foundation
import SwiftUI


//MARK: Input fields

struct Textfield : View {
    let title: String
    let contentType : UITextContentType
    let keyboardType : UIKeyboardType
    let labelWidth: CGFloat
    
    @Binding var output : String
    
    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .modifier(LabelText())
                .frame(width: labelWidth, alignment: .trailing)
            
            TextField("Tap to enter...", text: $output)
                .onSubmit {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .textFieldStyle(DefaultTextfieldStyle())
                .textContentType(contentType)
                .keyboardType(keyboardType)
        }
        .frame(height: 60)
    }
}

struct SecureTextfield : View {
    let title: String
    let labelWidth: CGFloat
    
    @Binding var output : String
    
    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .modifier(LabelText())
                .frame(width: labelWidth, alignment: .trailing)
            
            SecureField("Tap to enter...", text: $output)
                .onSubmit {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .textFieldStyle(DefaultTextfieldStyle())
                .textContentType(.password)
        }
        .frame(height: 60)
    }
}



struct MainButton : View {
    let title: String
    let image: String
    
    var body: some View {
        if image == "" {
            Text(title)
                .modifier(ClassicButtonText())
        } else {
            Label(title, systemImage: image)
                .modifier(ClassicButtonText())
        }
    }
}

struct SubButton : View {
    let title: String
    
    var body: some View {
        Text(title)
            .modifier(ClassicSubButtonText())
    }
}

struct ConnectionView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack {
            let connection = self.appState.inappState.connection
            let image = (self.appState.inappState.connection == .connected) ? "antenna.radiowaves.left.and.right" : (self.appState.inappState.connection == .disconnected) ? "antenna.radiowaves.left.and.right.slash" : self.appState.inappState.connection == .searching ? "magnifyingglass" : "antenna.radiowaves.left.and.right.slash"
            
            Label(self.appState.inappState.connection.rawValue, systemImage: image)
                .modifier(ClassicText(height: 90))
            
            if connection == .searching {
                ProgressView()
            } else {
                Button(action: {
                    self.appState.inappState.connection = self.appState.inappState.connection == .connected ? .disconnected : (self.appState.inappState.connection == .disconnected || self.appState.inappState.connection == .retry) ? .searching : .connected
                    
                    if self.appState.inappState.connection == .searching {
                        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
                            if self.appState.inappState.connection == .searching {
                                self.appState.inappState.connection = .retry
                            }
                            timer.invalidate()
                        }
                    }
                }) {
                    SubButton(title: self.appState.inappState.connection == .connected ? "Disconnect" : self.appState.inappState.connection == .disconnected ? "Connect" : "Retry")
                }
                .buttonStyle(ClassicButtonStyle(useGradient: true))
            }
        }
        .padding(.all, 10)
        .cornerRadius(20)
        .background(MyColours.b2)
    }
}
