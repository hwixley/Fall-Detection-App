//
//  fall_detectorApp.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI

struct InAppState {
    var page: Page
    var connection: Connection
    var user: User? = nil
    
    init(page: Page, connection: Connection, user: User? = nil) {
        self.page = page
        self.connection = connection
        self.user = user
    }
}

enum Page {
    case entry
    case login
    case register
    case main
}

enum Connection: String {
    case disconnected = "Disconnected"
    case searching = "Searching"
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
    @Published var inappState: InAppState = InAppState(page: .entry, connection: .disconnected, user: nil)
    
    init(inappState: InAppState) {
        self.inappState = inappState
    }
}

@main
struct fall_detectorApp: App {
    @ObservedObject var appState = AppState(inappState: InAppState(page: .entry, connection: .disconnected, user: nil))
    
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
            }
        }
    }
}
