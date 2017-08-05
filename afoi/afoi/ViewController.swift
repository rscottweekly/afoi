//
//  ViewController.swift
//  afoi
//
//  Created by Ross Scott-Weekly on 26/7/17.
//  Copyright © 2017 Ross Scott-Weekly. All rights reserved.
//

import UIKit

enum afoiError : Error {
  case dataFilesMissing
}


class ViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var weightSlider: UISlider!
  
  @IBOutlet weak var weightText: UITextField!
  
  @IBOutlet weak var doseLabel: UILabel!
  
  @IBOutlet weak var dataView: UIWebView!
  @IBOutlet weak var routeControl: UISegmentedControl!
  
  private var _weight = 70
  
  private var template : OutputTemplate?
  
  let minWeight = 30
  let maxWeight = 100
  let maxDosePerKG = 9
  
  var weight : Int {
    get {
      return self._weight
    }
    
    set(newWeight) {
      _weight  = newWeight
      self.weightSlider.value = Float(newWeight)
      self.weightText.text = "\(newWeight)kg"
      self.doseLabel.text = "\(newWeight * self.maxDosePerKG)mg"
      
      self.setReloadHTMLNeeded()
    }
  }
  
  var route : Route {
    get {
      switch routeControl.selectedSegmentIndex {
      case 0: return .Nasal
      case 1: return .Oral
      default: return .Undefined
      }
    }
  }
  
  @IBAction func routeControlChanged(_ sender: UISegmentedControl) {
    self.setReloadHTMLNeeded()
  }
  
  @IBAction func weightSliderChanged(_ sender: UISlider) {
    self.weight = Int(sender.value)
  }
  
  @IBAction func weightTextBeginEdit(_ sender: UITextField) {
    print(self.weight)
    sender.text = "\(self.weight)"
    sender.selectAll(sender)
    
  }
  
  @IBAction func weightTextEndEdit(_ sender: UITextField) {
    let input = sender.text!
    let oldWeight  = self.weight
    var weightOut : Int?
    // test if its an Int
    if let weight = Float(input) {
      switch weight {
      case _ where weight < Float(self.minWeight):
        weightOut = self.minWeight
        
      case _ where weight > Float(self.maxWeight):
        weightOut = self.maxWeight
        
      default:
        weightOut = Int(round(weight))
      }
    }
    
    if (weightOut != nil) {
      self.weight = weightOut!
    }
    else {
      self.weight = oldWeight
    }
    
  }
  

  override func viewDidLoad() {
    self.weight = 70
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    guard let dosingFileName = Bundle.main.url(forResource: "dosing", withExtension: "json")
      else {
        assert (false)
    }
    
    guard let templateFileName = Bundle.main.url(forResource: "topicalisation_template", withExtension: "html")
      else {
        assert(false)
        
    }
    
    template = OutputTemplate(dataFileName: dosingFileName, templateFileName: templateFileName)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super  .viewDidAppear(animated)
    self.setReloadHTMLNeeded()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setReloadHTMLNeeded() {
    guard let htmlStr = self.template?.getFilledHTMLTemplate(weight: self.weight, route: self.route, withRounding: true) else{
      return
    }
    self.dataView.loadHTMLString(htmlStr, baseURL: Bundle.main.bundleURL)
  }


}

