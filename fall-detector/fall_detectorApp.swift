//
//  fall_detectorApp.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

struct InAppState {
    var page: Page
    var tab: Int
    var connection: Connection
    var fallDetection: Bool
    var user: User? = nil
    
    init(page: Page, tab: Int, connection: Connection, fallDetection: Bool, user: User? = nil) {
        self.page = page
        self.tab = tab
        self.connection = connection
        self.fallDetection = fallDetection
        self.user = user
    }
}

enum Page {
    case entry
    case login
    case register
    case main
    case account
    case about
    case help
    case settings
}

enum Connection: String {
    case disconnected = "Disconnected"
    case searching = "Searching for your device..."
    case retry = "We could not find your device. Please make sure it is turned on and try again."
    case connected = "Connected"
}


struct User {
    var info: Person
    var contacts: [Person]
    
    init(info: Person, contacts: [Person]) {
        self.info = info
        self.contacts = contacts
    }
}

struct Person {
    var id: String
    var name: String
    var email: String
    var phone: String
    
    init(id: String, name: String, email: String, phone: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}

class AppState: ObservableObject {
    @Published var inappState: InAppState = InAppState(page: .entry, tab: 0, connection: .disconnected, fallDetection: true)
    
    init(inappState: InAppState) {
        self.inappState = inappState
    }
}

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
