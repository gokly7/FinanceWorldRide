//
//  MainViewController.swift
//  FinanceWorldRide
//
//  Created by Alberto Ayuso on 9/6/24.
//


//TODO

//realizar una consulta cada 1:30h y ver si esa consulta a superado o bajado mas de un 5% del dia, notificacion en caso ese caso

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var actionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView
        actionTableView.dataSource = self
        actionTableView.delegate = self
        
        // Añade un observador para detectar cuando cargaron los datos de Finnhub
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .updateTableView, object: nil)
    }
    
     //Esto se ejecuta justo antes de destruir la view
    deinit {
         NotificationCenter.default.removeObserver(self, name: .updateTableView, object: nil)
     }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Finnhub.stockExchanges.count < 0 {
            return Finnhub.stockExchanges.count
        }else{
            return Finnhub.symbols.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = actionTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath){
        if Finnhub.isDataFetched {
              let dataFinnhub = Finnhub.stockExchanges[indexPath.row]
              cell.textLabel?.text = "El precio actual de \(dataFinnhub.symbol) es \(dataFinnhub.currentPrice)"
          } else {
              cell.textLabel?.text = "Cargando datos..."
          }
    }
    
    //Volvemos a ejecutar las func de tableView
    @objc func updateTableView() {
        actionTableView.reloadData()
    }
}
