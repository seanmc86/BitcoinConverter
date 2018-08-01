//
//  BitcoinConverterTests.swift
//  BitcoinConverterTests
//
//  Created by Sean McCalgan on 2018/07/26.
//  Copyright © 2018 Sean McCalgan. All rights reserved.
//

import XCTest
@testable import BitcoinConverter

class BitcoinConverterTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    var converterEntryTest: ConverterViewController!
    var dataManagerTest: DataManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        converterEntryTest = ConverterViewController()
        dataManagerTest = DataManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUnderTest = nil
        converterEntryTest = nil
        dataManagerTest = nil
        super.tearDown()
    }
    
    func testValidAPICallRates() {
        // given
        let url = URL(string: "https://api.mybitx.com/api/1/ticker?pair=XBTZAR")

        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testValidAPICallTrades() {
        // given
        let url = URL(string: "https://api.mybitx.com/api/1/trades?pair=XBTZAR")
        
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
