//  templating.swift
//  afoi
//
//  Created by Ross Scott-Weekly on 4/8/17.
//  Copyright © 2017 Ross Scott-Weekly. All rights reserved.
//

import Foundation
import Mustache

class OutputTemplate {
  var dataFileName : URL!
  var templateFileName : URL!
  
  var dosingData : [DoseData]!
  
  private func loadJSON() {
    let data = try! Data(contentsOf: self.dataFileName)
    let json_data = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
    self.dosingData = [DoseData]()
    for val in json_data {
       try! self.dosingData?.append(DoseData(from_json: val as! [String: Any]))
    }

  }
  
  private func getCorrectDoseData(weight: Int, route: Route) -> DoseData?
  {
    for dd in dosingData {
      if (dd.min_weight <= weight) && (weight <= dd.max_weight) && (dd.route == route) {
        return dd
      }
    }
    return nil
  }
  
  public func getFilledHTMLTemplate(weight: Int, route: Route) -> String? {
    guard let doseDataChosen = getCorrectDoseData(weight: weight, route: route) else { return nil }
    
    return getFilledHTMLTemplate(withDictionary: doseDataChosen.asDictionary())

  }
  
  public func getFilledHTMLTemplate(weight: Int, route: Route, withRounding:Bool) -> String? {
    guard let doseDataChosen = getCorrectDoseData(weight: weight, route: route) else { return nil }
    return getFilledHTMLTemplate(withDictionary: doseDataChosen.asDictionary(withRounding: withRounding))
    
  }
  
  public func getFilledHTMLTemplate(withDictionary dictionary: [String: Any]) -> String? {
    let template = try! Template(URL: self.templateFileName)
    let rendering = try! template.render(dictionary)
    
    return rendering
  }
  
  
  init(dataFileName dfName: URL, templateFileName tfName: URL){
    self.dataFileName = dfName
    self.templateFileName = tfName
    
    self.loadJSON()
  }
}
