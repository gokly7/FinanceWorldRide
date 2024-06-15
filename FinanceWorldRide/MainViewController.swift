//
//  MainViewController.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 9/6/24.
//


//TODO

//arquitectura base, separar las cosas y comentar
//realizar una consulta cada 1:30h y ver si esa consulta a superado o bajado mas de un 5% del dia, notificacion en caso ese caso

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var actionTableView: UITableView!
    
    private let finnhub = Finnhub()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView settings
        actionTableView.dataSource = self
        actionTableView.delegate = self
        
        //Start API for load Stock Exchange
        finnhub.fetchAllStockMarketData()
        
        FWRNotifications.scheduleNotifications()
        
        // Add an observer for data Finnhub
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .updateTableView, object: nil)
    }
    /**
     The instance of a class is about to be destroyed
     */
    deinit {
         NotificationCenter.default.removeObserver(self, name: .updateTableView, object: nil)
     }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Finnhub.symbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = actionTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath){
        if finnhub.isDataFetched {
              let dataFinnhub = Finnhub.stockExchanges[indexPath.row]
              cell.textLabel?.text = "El precio actual de \(dataFinnhub.symbol) es \(dataFinnhub.currentPrice)"
          } else {
              cell.textLabel?.text = "Cargando datos..."
          }
    }
    
    @objc func updateTableView() {
        actionTableView.reloadData()
    }
}
