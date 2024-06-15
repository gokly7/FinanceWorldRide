//
//  Finnhub.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 14/6/24.
//

import Foundation

class Finnhub {
    
    static let symbols = ["LLY", "GOOGL", "MDB", "AMD", "TTWO", "NVDA"]
    static var stockExchanges : [StockExchange] = []
    private let apiKey = "cpmb3u1r01quf620qn60cpmb3u1r01quf620qn6g"
    
    var isDataFetched = false
    
    private func fetchStockMarketData(for symbol: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = URL(string: "https://finnhub.io/api/v1/quote?symbol=\(symbol)&token=\(apiKey)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])))
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
    }
    
    func fetchAllStockMarketData() {
        //Task group async
        let dispatchGroup = DispatchGroup()
        
        for symbol in Finnhub.symbols {
            dispatchGroup.enter()
            fetchStockMarketData(for: symbol) { result in
                switch result {
                case .success(let data):
                    if let currentPrice = data["c"] as? Double,  let openPrice = data["o"] as? Double{
                        Finnhub.stockExchanges.append(StockExchange(symbol: symbol, currentPrice: currentPrice, openPrice: openPrice))
                    }
                case .failure(let error):
                    Finnhub.stockExchanges.append(StockExchange(symbol: symbol, currentPrice: 0.00, openPrice: 0.00))
                    print("Symbol failed to load for: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        //All async tasks have finished
        dispatchGroup.notify(queue: .main) {
            print("All data fetched.")
            self.isDataFetched = true
            NotificationCenter.default.post(name: .updateTableView, object: nil)
        }
    }
}
