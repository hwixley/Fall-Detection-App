//
//  APNFunctions.swift
//  fall-detector
//
//  Created by Harry Wixley on 27/02/2022.
//

import Foundation
import UserNotifications

func sendNotification() {
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = "A fall has been detected"
    content.body = "Your emergency contacts will be notified in 60s unless you cancel the alarm"
    content.categoryIdentifier = "alarm"
    content.sound = UNNotificationSound.default
    
    let stopAlarm = UNNotificationAction(identifier: "stop", title: "Stop Alarm, I am okay", options: [])
    let category = UNNotificationCategory(identifier: "fall-alarm", actions: [stopAlarm], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
    center.add(request)
}
