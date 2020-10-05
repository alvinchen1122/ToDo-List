//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Alvin Chen on 10/4/20.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
    
    static func autherizeLocalNotifications(viewController: UIViewController ) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("Notifications authorization granted")
            } else {
                print("the user has denied notifications")
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To recieve alerts for reminders, open the settings app, select To Do List > Notifications > Allow Notifications.")
                }
    
            }
        }
    }
    
    static func isAuthorized(completed: @escaping (Bool)->() ) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completed(false)
                return
            }
            if granted {
                print("Notifications authorization granted")
                completed(true)
            } else {
                print("the user has denied notifications")
                completed(false)
    
            }
        }
    }
    
    static func setCalendarNotification(title: String,  subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("Notifaction scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
}
