//
//  fall_detectorApp.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

@main
struct fall_detectorApp: App {
    @ObservedObject var appState = AppState(inappState: InAppState(page: .entry, tab: 0, connection: .connected, fallDetection: true))
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(MyColours.p0)
    }
    
    var body: some Scene {
        WindowGroup {
            switch appState.inappState.page {
            case .entry:
                EntryView()
                    .environmentObject(appState)
            case .login:
                LoginView()
                    .environmentObject(appState)
            case .register:
                RegisterView()
                    .environmentObject(appState)
            case .main:
                MainView()
                    .environmentObject(appState)
            case .account:
                mnAccountView()
                    .environmentObject(appState)
            case .about:
                mnAboutView()
                    .environmentObject(appState)
            case .help:
                mnHelpView()
                    .environmentObject(appState)
            case .settings:
                mnSettingsView()
                    .environmentObject(appState)
            }
        }
    }
}
