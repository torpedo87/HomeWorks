//
//  AlterDateFormat.swift
//  ZigzagProgram
//
//  Created by junwoo on 07/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import Foundation

struct AlterDateFormat {
  
  func addSecAndConvertToTwentyFour(currentTime: String, N: Int) -> String {
    
    var hour: Int = 0
    var min: Int = 0
    var sec: Int = 0
    
    let ampmAndTime = currentTime.components(separatedBy: " ")
    let ampm = ampmAndTime[0]
    let time = ampmAndTime[1].components(separatedBy: ":")
    let currentH = time[0]
    let currentM = time[1]
    let currentS = time[2]
    
    let extraH: Int = (N - N % 3600) / 3600
    let mWiths: Int = N - extraH * 3600
    let extraM: Int = (mWiths - mWiths % 60) / 60
    let extraS: Int = N - extraH * 3600 - extraM * 60
    let extraHourFromAmpm = convertToExtraHour(ampm: ampm, currentHour: currentH)
    
    hour =  extraHourFromAmpm + Int(currentH)! + extraH
    min = Int(currentM)! + extraM
    sec = Int(currentS)! + extraS
    
    let twentyFourTime = convertToTwentyFour(hour: hour, min: min, sec: sec)
    
    return twoDigits(num: twentyFourTime.0) + ":" + twoDigits(num: twentyFourTime.1)
      + ":" + twoDigits(num: twentyFourTime.2)
  }
  
  func convertToExtraHour(ampm: String, currentHour: String) -> Int {
    var extraHour: Int = 0
    if ampm == "AM" {
      if currentHour == "12" {
        extraHour = -12
      } else {
        extraHour = 0
      }
    } else {
      extraHour = 12
    }
    return extraHour
  }
  
  func convertToTwentyFour(hour: Int, min: Int, sec: Int) -> (Int, Int, Int) {
    
    let s = sec % 60
    let m = (min + (sec - s) / 60) % 60
    let h = (hour + ((min + (sec - s) / 60) - m) / 60) % 24
    
    return (h, m, s)
  }
  
  func twoDigits(num: Int) -> String {
    if String(num).count == 1 {
      return "0" + String(num)
    } else {
      return String(num)
    }
  }
}
