//
//  ViewController.swift
//  BitcoinConverter
//
//  Created by Sean McCalgan on 2018/07/26.
//  Copyright © 2018 Sean McCalgan. All rights reserved.
//

import UIKit
import Charts

class ConverterViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var textEntryBitcoin: UITextField!
    @IBOutlet weak var textEntryRand: UITextField!
    @IBOutlet weak var labelCurrentRate: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var refreshButtonOutlet: UIButton!
    
    // MARK: - Properties
    
    var viewModel: ConverterViewModel {
        return controller.viewModel
    }
    
    lazy var controller: ConverterController = {
        return ConverterController()
    }()
    
    lazy var currentExchangeRate: Double = {
        return 0.00
    }()
    
    // MARK: - Dynamic views
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()

        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.center.y
        //activityIndicator.frame = labelCurrentRate.frame.offsetBy(dx: 0, dy: 30)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(activityIndicator)
        
        return activityIndicator
    }()
    
    lazy var tradeGraph: LineChartView = {
        let tradeGraph = LineChartView()

        // Frame settings
        tradeGraph.backgroundColor = UIColor.black
        
        // Chart specific settings
        tradeGraph.scaleXEnabled = true
        tradeGraph.scaleYEnabled = true
        tradeGraph.legend.enabled = false
        tradeGraph.chartDescription?.enabled = false
        
        // Axis settings
        tradeGraph.leftAxis.labelTextColor = UIColor.white
        tradeGraph.rightAxis.labelTextColor = UIColor.white
        tradeGraph.xAxis.drawGridLinesEnabled = false
        tradeGraph.xAxis.drawLabelsEnabled = false
        
        chartView.addSubview(tradeGraph)
        chartView.layer.cornerRadius=5
        chartView.layer.borderWidth=2
        
        return tradeGraph
    }()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        controller.start()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // MARK: - Data binding
    
    func initBinding() {
        
        viewModel.currentRate.addObserver { [weak self] (currentRate) in
            if currentRate.isDouble {
                self?.currentExchangeRate = Double(currentRate)!
                self?.labelCurrentRate.isHidden = false
                self?.labelCurrentRate.text = "1 Bitcoin currently = \(currentRate) Rand"
            }
        }
        
        viewModel.lastTrades.addObserver { [weak self] (lastTrades) in
            self?.tradeGraph.data = lastTrades
            self?.tradeGraph.frame = (self?.chartView.bounds)!
        }
        
        viewModel.reloading.addObserver { [weak self] (reloading) in
            if reloading {
                self?.activityIndicator.startAnimating()
                self?.refreshButtonOutlet.isEnabled = false
            } else {
               self?.activityIndicator.stopAnimating()
                self?.refreshButtonOutlet.isEnabled = true
            }
        }
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func btcEditingChanged(_ sender: Any) {
        guard currentExchangeRate != 0.00 else { return }
        guard textEntryBitcoin.text != "" else  { return }

        if let btcValueEntered: Double = Double(textEntryBitcoin.text!.checkLeadingZero) {
            textEntryRand.text = String(format: "%.2f", (btcValueEntered * currentExchangeRate))
        }
        
    }
    
    @IBAction func zarEditingChanged(_ sender: Any) {
        guard currentExchangeRate != 0.00 else { return }
        guard textEntryRand.text != "" else { return }
        
        if let zarValueEntered: Double = Double(textEntryRand.text!.checkLeadingZero) {
            textEntryBitcoin.text = String(format: "%.6f", (zarValueEntered / currentExchangeRate))
        }

    }
    
    @IBAction func refreshButton(_ sender: Any) {
        controller.start()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


}

// MARK: - String Extensions

extension String {
    var isDouble: Bool {
        return Double(self) != nil
    }
}

extension String {
    var checkLeadingZero: String {
        let newString = self.replacingOccurrences(of: ",", with: ".")
        if self.first == "." {
            return "0\(newString)"
        } else {
            return newString
        }
        
    }
}
