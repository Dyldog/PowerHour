//
//  PowerHourGameNotificationManager.swift
//  PowerHour2
//
//  Created by Dylan Elliott on 25/9/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UserNotifications

extension UNNotificationRequest {
    static func powerHourNotification(triggerTime: Int) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "DRINK!"
        //content.body = "Buy some milk"
        content.sound = UNNotificationSound(named: "Drink.m4a")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(triggerTime),            repeats: false)
        let identifier = "PHGDrinkNotification-\(triggerTime)"
        
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
}


class PowerHourGameNotificationManager {
    static func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("User did not grant notification permissions")
            }
        }
    }
    static func addDrinkNotification(timeInterval: Int) {
        let notificationRequest =  UNNotificationRequest.powerHourNotification(triggerTime: timeInterval)
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                return
            }
            
            center.add(notificationRequest, withCompletionHandler: { (error) in
                if let error = error {
                    print("Error adding drink notification", error)
                }
            })
        }
        
    }

    static func createDrinkNotificationsIfPossible(for game : PowerHourGame) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        
        let notificationTimes = stride(from: game.timeRemaining(), to: 0, by: -game.drinkInterval)
        notificationTimes.forEach({ self.addDrinkNotification(timeInterval: $0) })
    }

    static func clearDrinkNotificationsIfPossible() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
