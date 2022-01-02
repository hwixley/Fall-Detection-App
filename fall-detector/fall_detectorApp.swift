//
//  fall_detectorApp.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

enum InAppState {
    case entry
    case login
    case register
    case home
}

class AppState: ObservableObject {
    @Published var inappState: InAppState = .entry
    
    init(inappState: InAppState) {
        self.inappState = inappState
    }
}

@main
struct fall_detectorApp: App {
    @ObservedObject var appState = AppState(inappState: .entry)
    
    var body: some Scene {
        WindowGroup {
            switch appState.inappState {
            case .entry:
                EntryView()
                    .environmentObject(appState)
            case .login:
                LoginView()
                    .environmentObject(appState)
            case .register:
                RegisterView()
                    .environmentObject(appState)
            case .home:
                MainView()
                    .environmentObject(appState)
            }
        }
    }
}
