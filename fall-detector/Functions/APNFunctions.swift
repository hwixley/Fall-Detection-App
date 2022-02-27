//
//  APNFunctions.swift
//  fall-detector
//
//  Created by Harry Wixley on 27/02/2022.
//

import Foundation
import UserNotifications

class APNHandling {
    let center = UNUserNotificationCenter.current()
    
    func requestAuth(completion: @escaping ((Bool) -> Void)) {
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("Permission granted: \(granted)")
            completion(granted)
        }
    }
    
    func sendNotification() {
        self.registerCategories()

        let content = UNMutableNotificationContent()
        content.title = "A fall has been detected"
        content.body = "Your emergency contacts will be notified in 60s unless you cancel the alarm"
        content.categoryIdentifier = "sosAlarm"
        content.sound = UNNotificationSound.default
        
        let stopAlarm = UNNotificationAction(identifier: "stop", title: "Stop Alarm, I am okay", options: [])
        let category = UNNotificationCategory(identifier: "fall-alarm", actions: [stopAlarm], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        self.center.add(request)
    }

    func registerCategories() {
        
        let sos = UNNotificationAction(identifier: "sos", title: "Yes, send help", options: .foreground)
        let fine = UNNotificationAction(identifier: "fine", title: "I am fine", options: .foreground)
        let sosCat = UNNotificationCategory(identifier: "sosAlarm", actions: [fine, sos], intentIdentifiers: [])
        
        self.center.setNotificationCategories([sosCat])
    }
}
