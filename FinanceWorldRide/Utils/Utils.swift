//
//  Utils.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 11/6/24.
//

import Foundation

class Utils {
    /**
        Check if the Stock Exchange nasdaq is open
     */
    static func isOpenNowNasdaq() -> Bool{
        let currentDateTime = Date()
        let timeZone = TimeZone(identifier: "Europe/Madrid")!
        
        // Create calendar with time zone
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let hour = calendar.component(.hour, from: currentDateTime)
        
        if hour >= 16 && hour < 21 {
            return true
        } else {
            return false
        }
    }
    
    /**
        Format number so that only 2 decimal appear
     */
    static func formattedPercentage(_ percentage: Double) -> String{
        return String(format: "%.2f", percentage)
    }
    
}
    
