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
    var taskSuccess: Bool? = nil
    var connection: Connection = .disconnected
    var fallDetection: Bool = true
    var notifAuth: Bool = false
}

enum Page {
    case entry
    case login
    case resetpass
    case register
    case register1
    case register2
    case register3
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
    
    func isEqual(user: User) -> Bool{
        if id == user.id && name == user.name && email == user.email && password == user.password && phone == user.phone && yob == user.yob && height == user.height && weight == user.weight && is_female == user.is_female && medical_conditions == user.medical_conditions && areContactsEqual(contacts2: user.contacts) {
            return true
        } else {
            return false
        }
    }
    
    private func areContactsEqual(contacts2: [Person]) -> Bool {
        if contacts.count != contacts2.count {
            return false
        } else {
            var count = 0
            
            for c in contacts {
                for c2 in contacts2 {
                    if c.isEqual(pers: c2) {
                        count += 1
                        break
                    }
                }
            }
            if count == contacts.count {
                return true
            } else {
                return false
            }
        }
    }
}

struct Person: Hashable {
    var id: String
    var name: String
    var phone: String
    var isOnFirebase: Bool
    
    func isEqual(pers: Person) -> Bool {
        if id == pers.id && name == pers.name && phone == pers.phone && isOnFirebase == pers.isOnFirebase {
            return true
        } else {
            return false
        }
    }
}

class AppState: ObservableObject {
    @Published var inappState: InAppState
    
    init(inappState: InAppState = InAppState(page: .entry, tab: 0, connection: .disconnected, fallDetection: true)) {
        self.inappState = inappState
    }
}
