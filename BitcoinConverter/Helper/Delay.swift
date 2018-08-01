//
//  Delay.swift
//  BitcoinConverter
//
//  Created by Sean McCalgan on 2018/07/30.
//  Copyright © 2018 Sean McCalgan. All rights reserved.
//

import Foundation

// Included custom delay but unused for now

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
