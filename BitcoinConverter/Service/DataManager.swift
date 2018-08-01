//
//  DataManager.swift
//  BitcoinConverter
//
//  Created by Sean McCalgan on 2018/07/26.
//  Copyright © 2018 Sean McCalgan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DataManagerError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
    
}

class DataManager {
    
    // MARK: - Typealiases
    
    typealias RatesCompletion = (CurrentRate?, DataManagerError?) -> ()
    typealias TradesCompletion = ([LastTrades]?, DataManagerError?) -> ()
    
    // MARK: - Data properties
    
    private lazy var currentRate: CurrentRate = {
        let currentRate = CurrentRate(lastPrice: "?")
        return currentRate
    }()
    
    private lazy var lastTrades: [LastTrades] = {
        var lastTrades = [LastTrades]()
        return lastTrades
    }()
    
    // MARK: - API Setup
    
    private let ratesURL: URL = URL(string: "https://api.mybitx.com/api/1/ticker?pair=XBTZAR")!
    private let tradesURL: URL = URL(string: "https://api.mybitx.com/api/1/trades?pair=XBTZAR")!

    func fetchRates(completion: @escaping RatesCompletion) {
        // Create Data Task
        URLSession.shared.dataTask(with: self.ratesURL) { (data, response, error) in
            DispatchQueue.global().async {
                self.didFetchRates(data: data, response: response, error: error, completion: completion)
            }
            }.resume()
    }
    
    func fetchTrades(completion: @escaping TradesCompletion) {
        // Create Data Task
        URLSession.shared.dataTask(with: self.tradesURL) { (data, response, error) in
            DispatchQueue.global().async {
                self.didFetchTrades(data: data, response: response, error: error, completion: completion)
            }
            }.resume()
    }
    
    // MARK: - Helper Methods
    
    private func didFetchRates(data: Data?, response: URLResponse?, error: Error?, completion: RatesCompletion) {
        if let _ = error {
            completion(nil, .failedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Decode JSON
                    let json = try JSON(data: data)
                    guard let result = json["last_trade"].string else { return }
                    let currentRate: CurrentRate = CurrentRate(lastPrice: result)
                    
                    // Invoke Completion Handler
                    completion(currentRate, nil)
                    
                } catch {
                    // Invoke Completion Handler
                    completion(nil, .invalidResponse)
                }
                
            } else {
                completion(nil, .failedRequest)
            }
            
        } else {
            completion(nil, .unknown)
        }
    }
    
    private func didFetchTrades(data: Data?, response: URLResponse?, error: Error?, completion: TradesCompletion) {
        if let _ = error {
            completion(nil, .failedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Decode JSON
                    let json = try JSON(data: data)
                    
                    var dataArray: [LastTrades] = []
                    for (_,subJson):(String, JSON) in json["trades"] {
                        let dataPoint = subJson["price"].stringValue
                        dataArray.append(CurrentRate(lastPrice: dataPoint))
                    }
                    
                    // Invoke Completion Handler
                    completion(dataArray, nil)
                    
                } catch {
                    // Invoke Completion Handler
                    completion(nil, .invalidResponse)
                }
                
            } else {
                completion(nil, .failedRequest)
            }
            
        } else {
            completion(nil, .unknown)
        }
    }

}
