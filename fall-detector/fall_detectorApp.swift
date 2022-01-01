//
//  fall_detectorApp.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI


enum SuperState {
    case onboarding
    case inapp
}

enum OnboardingState {
    case entry
    case login
    case register
}

enum InAppState {
    case entry
}

class AppState: ObservableObject {
    @Published var superState: SuperState = .onboarding
    @Published var onboardingState: OnboardingState = .entry
    @Published var inappState: InAppState = .entry
    
    init(superState: SuperState, onboardingState: OnboardingState, inappState: InAppState) {
        self.onboardingState = onboardingState
        self.superState = superState
        self.inappState = inappState
    }
}

@main
struct fall_detectorApp: App {
    @ObservedObject var appState = AppState(superState: .onboarding, onboardingState: .entry, inappState: .entry)
    
    var body: some Scene {
        WindowGroup {
            if appState.superState == .onboarding {
                switch appState.onboardingState {
                case .entry:
                    EntryView()
                        .environmentObject(appState)
                case .login:
                    LoginView()
                        .environmentObject(appState)
                case .register:
                    RegisterView()
                        .environmentObject(appState)
                }
            }
        }
    }
}
