//
//  AppState.swift
//  fall-detector
//
//  Created by Harry Wixley on 21/01/2022.
//

import Foundation

struct InAppState {
    var page: Page = .entry
    var tab: Int = 0
    var showSpinner: Bool = false
    var regSection: Int = 0
    var connection: Connection = .disconnected
    var fallDetection: Bool = true
    var user: User? = nil
}

enum Page {
    case entry
    case login
    case resetpass
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
    var id: String
    var name: String
    var email: String
    var password: String
    var phone: String
    var yob: Int
    var height: Int
    var weight: Int
    var is_female: Bool
    var medical_conditions: String
    var contacts: [Person]
}

struct Person {
    var id: String
    var name: String
    var email: String
    var phone: String
}

class AppState: ObservableObject {
    @Published var inappState: InAppState = InAppState(page: .entry, tab: 0, regSection: 0, connection: .disconnected, fallDetection: true)
    
    init(inappState: InAppState) {
        self.inappState = inappState
    }
}
