//
//  helpers.swift
//  afoi
//
//  Created by Ross Scott-Weekly on 5/8/17.
//  Copyright © 2017 Ross Scott-Weekly. All rights reserved.
//

import Foundation

func getNegativePower(value:Int)->Double {
  return 1/NSDecimalNumber(decimal: pow(10,value)).doubleValue
}

func testIfWholeNumber(_ val:Double, withPrecision:Int = 4) -> Bool {
  let rounded = val.rounded(.toNearestOrAwayFromZero)
  print("Val: \(val) | Rounded: \(rounded) | Diff \(abs(val-rounded)) | Precision \(getNegativePower(value: withPrecision)) ")
  return abs(val-rounded) < getNegativePower(value: withPrecision)
}

func dictionaryRoundToInt(_ dict: inout [String: Any]) {
  for item in dict {
    if item.value is Float  {
      let valFixed = item.value as! Float
      if testIfWholeNumber(Double(valFixed)) {
        dict[item.key] = Int(valFixed.rounded(.toNearestOrAwayFromZero))
        print("Mutating \(item.key) to \(dict[item.key]!)")
      }
    }
  }
}
