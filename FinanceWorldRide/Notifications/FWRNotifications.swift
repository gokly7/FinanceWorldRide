//
//  Notifications.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 12/6/24.
//

import Foundation
import UserNotifications

class FWRNotifications{
    
    private func checkPriceToNotify() {
        loadStockFromAPI()
        
        // Añade un observador para detectar cuando cargaron los datos de Finnhub
        NotificationCenter.default.addObserver(self, selector: #selector(loadStockMarket), name: .loadStockMarket, object: nil)
    }
    
    /**
        Send a notification if the stock has risen or fallen more than 4%
     */
    @objc private func loadStockMarket() {
        for stock in Finnhub.stockExchangesNotify{
            if let openPrice = stock.openPrice{
                if stock.currentPrice > openPrice * 1.04 {
                    let percentage = ((stock.currentPrice - openPrice) / openPrice) * 100
                    sendNotification(title: "\(stock.symbol) esta subiendo", body: "\(stock.symbol) ha subido un \(Utils.formattedPercentage(percentage))%")
                }else if stock.currentPrice < openPrice * 0.96{
                    let percentage = ((openPrice - stock.currentPrice) / openPrice) * 100
                    sendNotification(title: "\(stock.symbol) esta bajando", body: "\(stock.symbol) ha bajado un \(Utils.formattedPercentage(percentage))%")
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: .loadStockMarket, object: nil)
    }

    /**
        Notification settings
     */
    private func sendNotification(title: String, body: String) {
         let content = UNMutableNotificationContent()
         content.title = title
         content.body = body
        content.sound = UNNotificationSound.default

         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
         let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)

         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }
    
    
     func scheduleWhenStocksOpen() {
        let calendar = Calendar.current
        let now = Date()

        var dateComponents = DateComponents()
        dateComponents.hour = 15
        dateComponents.minute = 30
        guard let startTime = calendar.date(from: dateComponents) else { return }
        
        dateComponents.hour = 22
        dateComponents.minute = 0
        guard let endTime = calendar.date(from: dateComponents) else { return }

        let weekdays = [2, 3, 4, 5, 6] // Lunes a Fiernes (2 = Lunes, ..., 6 = Viernes)
        let currentWeekday = calendar.component(.weekday, from: now)

         // Comprueba si hoy es un día laborable
         if weekdays.contains(currentWeekday) {
             // Compruebe si la hora actual es entre las 15:30 y las 22:00
             if now >= startTime && now <= endTime {
                 self.checkPriceToNotify()
                 return
             }
         }
         loadStockFromAPI()
     }
    
    /**
        Send the request to the API to load the Exchange stock data
     */
    private func loadStockFromAPI(){
        let finnhub = Finnhub()
        
        //Start API for load Stock Exchange
        finnhub.fetchAllStockMarketData()
    }
}
