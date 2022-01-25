//
//  CustomViews.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import Foundation
import SwiftUI


//MARK: Input fields

struct Warning : View {
    let text: String
    
    var body: some View {
        Label(text, systemImage: "exclamationmark.triangle.fill")
            .foregroundColor(Color(UIColor.systemPink))
    }
}

struct CustLabel : View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .modifier(SubtitleText())
                .multilineTextAlignment(.leading)
            Text(value)
                .modifier(LabelText())
        }
    }
}


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
    var width: CGFloat? = nil
    
    var body: some View {
        Text(title)
            .modifier(ClassicSubButtonText(width: width ?? UIScreen.screenWidth - 20))
    }
}

struct ConnectionView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 15) {
            let connection = self.appState.inappState.connection
            let image = (self.appState.inappState.connection == .connected) ? "antenna.radiowaves.left.and.right" : (self.appState.inappState.connection == .disconnected) ? "antenna.radiowaves.left.and.right.slash" : self.appState.inappState.connection == .searching ? "magnifyingglass" : "exclamationmark.circle"
            
            Text("Connection Status:")
                .modifier(DefaultText(size: 25))
                .multilineTextAlignment(.center)
            
            Divider()
            
            Label(self.appState.inappState.connection.rawValue, systemImage: image)
                .modifier(DefaultText(size: 22))
                .multilineTextAlignment(.center)
            
            if connection == .searching {
                ProgressView()
                    .padding(.bottom, 10)
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
                    SubButton(title: self.appState.inappState.connection == .connected ? "Disconnect" : self.appState.inappState.connection == .disconnected ? "Connect" : "Try again", width: UIScreen.screenWidth - 40)
                }
                .buttonStyle(ClassicButtonStyle(useGradient: true))
            }
        }
        .frame(width: UIScreen.screenWidth - 20)
        .modifier(VPadding(pad: 10))
        .background(MyColours.b1)
    }
}

struct DetectorView: View {
    @ObservedObject var appState: AppState
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            Toggle(isOn: $appState.inappState.fallDetection) {
                Label("Fall detection is " + (self.appState.inappState.fallDetection ? "ON" : "OFF"), systemImage: "waveform.path.ecg")
            }
            .onChange(of: appState.inappState.fallDetection, perform: { value in
                if !value {
                    self.showAlert = true
                }
            })
            .alert("Are you sure you want to turn off fall detection?", isPresented: $showAlert) {
                Button("Yes", role: .destructive) {
                    self.appState.inappState.fallDetection = false
                }
                .modifier(ClassicButtonText())
                Button("No, cancel", role: .cancel) {
                    self.showAlert = false
                    self.appState.inappState.fallDetection = true
                }
                .modifier(ClassicButtonText())
            }
            .labelStyle(CustomLabelStyle())
            .modifier(DefaultText(size: 30))
            .modifier(HPadding(pad: 10))
            .tint(MyColours.p0)
        }
        .frame(width: UIScreen.screenWidth - 20, height: 100)
        .modifier(VPadding(pad: 10))
        .background(MyColours.b1)
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden && !remove {
            self.hidden()
        } else {
            self
        }
    }
}
