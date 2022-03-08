//
//  APNFunctions.swift
//  fall-detector
//
//  Created by Harry Wixley on 27/02/2022.
//

import Foundation
import UserNotifications
import UIKit

class APNHandling {
    let center = UNUserNotificationCenter.current()
    
    var deviceToken : String = ""
    
    func requestAuth(completion: @escaping ((Bool) -> Void)) {
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("Permission granted: \(granted)")
            if granted {
                self.getNotifSettings()
            }
            completion(granted)
        }
    }
    
    func getNotifSettings() {
        self.center.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func sendNotification() {
        print("sending notification")
        //let center = UNUserNotificationCenter.current()
        
        self.requestAuth { granted in
            if granted {
                self.registerCategories()

                let content = UNMutableNotificationContent()
                content.title = "Fall detected!"
                content.body = "Your emergency contacts will be notified in 60s unless you cancel the alarm"
                content.categoryIdentifier = "sosAlarm"
                content.interruptionLevel = .critical
                content.sound = UNNotificationSound.defaultCritical
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.center.add(request) { error in
                    if error != nil {
                        print("Error sending notification: \(error!)")
                    } else {
                        print("no error")
                    }
                }
            }
        }
    }

    func registerCategories() {
        
        let sos = UNNotificationAction(identifier: "sos", title: "Yes, send help", options: .foreground)
        let fine = UNNotificationAction(identifier: "fine", title: "I am fine", options: .destructive)
        let sosCat = UNNotificationCategory(identifier: "sosAlarm", actions: [fine, sos], intentIdentifiers: [])
        
        self.center.setNotificationCategories([sosCat])
    }
}
