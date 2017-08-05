//
//  doseData.swift
//  Pods
//
//  Created by Ross Scott-Weekly on 4/8/17.
//
//

import Foundation

enum DoseDataError {
  case parsingError
}

enum Route : CustomStringConvertible {
  case Oral
  case Nasal
  case Undefined
  
  static func getRouteFromString(_ route_str:String) -> Route {
    switch route_str.uppercased(){
      case "ORAL":
        return .Oral
      case "NASAL":
        return .Nasal
    default:
        return .Undefined
    }}
  
  public var description: String {
    switch self {
    case .Oral: return "Oral"
    case .Nasal: return "Nasal"
    case .Undefined: return "Undefined"
    }
  }
}

struct DoseData : CustomStringConvertible {
  let route: Route!
  let min_weight: Int!
  let max_weight: Int!
  let glyco_dose: Int!
  let neb_lig_dose:  Float!
  let neb_lig_pct:  Int!
  let co_phenyl_dose:  Int!
  let nasal_lig:  Float!
  let nasal_lig_pct:  Int!
  let op_lig_dose:  Float!
  let op_lig_pct:  Int!
  let sayg_lig_epiglottis_dose:  Float!
  let sayg_lig_epiglottis_pct:  Int!
  let sayg_lig_leftcord_dose: Float!
  let sayg_lig_leftcord_pct: Int!
  let sayg_lig_rightcord_dose: Float!
  let sayg_lig_rightcord_pct: Int!
  let total_lig: Int!
  let is_neb: Bool!
  let is_nose_prep: Bool!
  let is_op_preparation: Bool!
  let is_oral: Bool!
  let is_dose_range: Bool!
  let Lig_Calc: Float!
  
  static func strToBool(string str: String) -> Bool {
    if str.uppercased() == "T" {
      return true
    }
    else {
      return false
    }
  }
  
  init(from_json val:[String: Any]) throws {
    self.route = Route.getRouteFromString(val["route"] as! String)
    self.min_weight = val["min_weight"] as! Int
    self.max_weight = val["max_weight"] as! Int
    self.glyco_dose = val["glyco_dose"] as! Int
    self.neb_lig_dose = val["neb_lig_dose"] as! Float
    self.neb_lig_pct = val["neb_lig_pct"] as! Int
    self.co_phenyl_dose = val["co_phenyl_dose"] as! Int
    self.nasal_lig = val["nasal_lig"] as! Float
    self.nasal_lig_pct = val["nasal_lig_pct"] as! Int
    self.op_lig_dose = val["op_lig_dose"] as! Float
    self.op_lig_pct = val["op_lig_pct"] as! Int
    self.sayg_lig_epiglottis_dose = val["sayg_lig_epiglottis_dose"] as! Float
    self.sayg_lig_leftcord_dose = val["sayg_lig_leftcord_dose"] as! Float
    self.sayg_lig_rightcord_dose = val["sayg_lig_rightcord_dose"] as! Float
    self.sayg_lig_epiglottis_pct = val["sayg_lig_epiglottis_pct"] as! Int
    self.sayg_lig_leftcord_pct = val["sayg_lig_leftcord_pct"] as! Int
    self.sayg_lig_rightcord_pct = val["sayg_lig_rightcord_pct"] as! Int
    self.total_lig = val["total_lig"] as! Int
    self.Lig_Calc = val["Lig-Calc"] as! Float
    self.is_neb = DoseData.strToBool(string: val["is_neb"] as! String)
   	self.is_nose_prep = DoseData.strToBool(string: val["is_nose_prep"] as! String)
    self.is_op_preparation = DoseData.strToBool(string:val["is_op_preparation"] as! String)
    self.is_oral = DoseData.strToBool(string:val["is_oral"] as! String)
    self.is_dose_range = DoseData.strToBool(string:val["is_dose_range"] as! String)

  }
  
  public var description: String {
    return "[obj] Dose Data for \(self.route!) route from \(self.min_weight!)kg to \(self.max_weight!)kg"
  }
  
  public func asDictionary() -> [String: Any] {
    var ret_val = [String: Any]()
    ret_val["route"] = self.route.description
    ret_val["min_weight"] = self.min_weight
    ret_val["max_weight"] = self.max_weight <= 100 ? self.max_weight : 100
    ret_val["glyco_dose"] = self.glyco_dose
    ret_val["neb_lig_dose"] = self.neb_lig_dose
    ret_val["neb_lig_pct"] = self.neb_lig_pct
    ret_val["co_phenyl_dose"] = self.co_phenyl_dose
    ret_val["nasal_lig"] = self.nasal_lig
    ret_val["nasal_lig_pct"] = self.nasal_lig_pct
    ret_val["op_lig_dose"] = self.op_lig_dose
    ret_val["op_lig_pct"] = self.op_lig_pct
    ret_val["sayg_lig_epiglottis_dose"] = self.sayg_lig_epiglottis_dose
    ret_val["sayg_lig_leftcord_dose"] = self.sayg_lig_leftcord_dose
    ret_val["sayg_lig_rightcord_dose"] = self.sayg_lig_rightcord_dose
    ret_val["sayg_lig_epiglottis_pct"] = self.sayg_lig_epiglottis_pct
    ret_val["sayg_lig_leftcord_pct"] = self.sayg_lig_leftcord_pct
    ret_val["sayg_lig_rightcord_pct"] = self.sayg_lig_rightcord_pct
    ret_val["total_lig"] = self.total_lig
    ret_val["Lig-Calc"] = self.Lig_Calc
    ret_val["is_neb"] = self.is_neb
   	ret_val["is_nose_prep"] = self.is_nose_prep
    ret_val["is_op_preparation"] = self.is_op_preparation
    ret_val["is_oral"] = self.is_oral
    ret_val["is_dose_range"] = self.is_dose_range
    
    return ret_val
  }
  
  public func asDictionary(withRounding: Bool) -> [String: Any] {
    var dict = self.asDictionary()
    dictionaryRoundToInt(&dict)
    return dict
  }
  
}
