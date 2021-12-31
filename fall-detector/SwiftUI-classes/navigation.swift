//
//  navigation.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import Foundation
import SwiftUI

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
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
    }
}
