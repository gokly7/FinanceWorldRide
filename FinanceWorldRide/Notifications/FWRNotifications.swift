//
//  Notifications.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 12/6/24.
//

import Foundation
import UserNotifications

class FWRNotifications{
    
    static func scheduleNotifications() {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Recordatorio"
            content.body = "Han pasado 2 horas"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 28800, repeats: true)
            
            let request = UNNotificationRequest(identifier: "twoHourNotification", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if let error = error {
                    print("Error al añadir notificación: \(error.localizedDescription)")
                }
            }
    }
}
