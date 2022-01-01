//
//  CustomStyles.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import Foundation
import UIKit
import SwiftUI

//MARK: Navigation

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct NavigationBarStyle: ViewModifier {
    var title: String
    @Binding var mode: Binding<PresentationMode>
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont(name: fontfamily, size: 30)!]
            })
            .navigationBarItems(leading:
                Button(action: {
                    mode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                        Text("Back")
                            .foregroundColor(.white)
                    }
                })
    }
}

//MARK: Buttons

struct ClassicButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
    }
}

struct ClassicSubButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
    }
}


//MARK: Textfields

struct DefaultTextfieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .modifier(VPadding(pad: 15))
            .modifier(HPadding(pad: 10))
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(MyColours.b2)
            ).padding(.trailing, 10)
    }
}
