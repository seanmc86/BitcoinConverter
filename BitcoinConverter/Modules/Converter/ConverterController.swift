//
//  ConverterController.swift
//  BitcoinConverter
//
//  Created by Sean McCalgan on 2018/07/26.
//  Copyright © 2018 Sean McCalgan. All rights reserved.
//

import Foundation
import Charts

class ConverterController {
    let dataManager: DataManager
    let viewModel: ConverterViewModel
    
    init(viewModel: ConverterViewModel = ConverterViewModel(), dataManager: DataManager = DataManager()) {
        self.viewModel = viewModel
        self.dataManager = dataManager
    }
    
    // MARK: - Data manager observers
    
    func start() {
        self.viewModel.currentRate.value = "?"
        //self.viewModel.lastTrades.value = LineChartData()
        self.viewModel.reloading.value = true
        
        dataManager.fetchRates { [weak self] (currentRate,DataManagerError)  in
            guard currentRate != nil else {
                self?.viewModel.reloading.value = false
                return
            }
            
            self?.buildViewModelRates(rates: currentRate!)
        }
        dataManager.fetchTrades { [weak self] (lastTrades,DataManagerError)  in
            guard lastTrades != nil else {
                self?.viewModel.reloading.value = false
                return
            }
            
            self?.buildViewModelTrades(trades: lastTrades!)
        }
    }
    
    // MARK: - Data source
    
    func buildViewModelRates(rates: CurrentRate) {
        self.viewModel.currentRate.value = rates.lastPrice
    }
    
    func buildViewModelTrades(trades: [LastTrades]) {
        
        // Entry array that is used in the dataset
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<trades.count/10 {
            let value = ChartDataEntry(x: Double(i), y: Double(trades[i].lastPrice)!)
            lineChartEntry.append(value)
        }
        
        // Add entries to dataset
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Last Trades")
        
        // Misc properties for line dataset
        line1.colors = [UIColor.init(red: 140/255, green: 180/255, blue: 240/255, alpha: 0.9)]
        line1.mode = .cubicBezier
        line1.drawCirclesEnabled = false
        line1.fillColor = NSUIColor.init(red: 140/255, green: 180/255, blue: 240/255, alpha: 0.9)
        line1.fillAlpha = 1.0
        line1.drawFilledEnabled = true
        line1.drawValuesEnabled = false
        
        // Add dataset to data object
        let data = LineChartData()
        data.addDataSet(line1)
        
        if data.dataSetCount != 0 {
            self.viewModel.lastTrades.value = data
        }
        self.viewModel.reloading.value = false
    }
    
}

/**/

