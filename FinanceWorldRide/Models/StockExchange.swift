//
//  StockExchange.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 14/6/24.
//

import Foundation

class StockExchange{
    
    public var symbol: String
    public var currentPrice: Double
    public var openPrice: Double
    
    init(symbol: String, currentPrice: Double, openPrice: Double) {
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.openPrice = openPrice
    }
}
