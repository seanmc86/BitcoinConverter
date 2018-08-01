//
//  ConverterViewModel.swift
//  BitcoinConverter
//
//  Created by Sean McCalgan on 2018/07/26.
//  Copyright © 2018 Sean McCalgan. All rights reserved.
//

import Charts

class ConverterViewModel {
    let currentRate = Observable<String>(value: "?")
    let lastTrades = Observable<LineChartData>(value: LineChartData())
    let reloading = Observable<Bool>(value: true)
}
