//
//  IsAvailableTime.swift
//  ZigzagProgram
//
//  Created by junwoo on 07/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import Foundation

//RangePattern : "월요일 10:00~11:00"
//TargetPattern : "월요일 10:00"
//TimeRange : (시작시간, 끝시간)

struct IsAvailableTime {
  
  let days = ["일", "월", "화", "수", "목", "금", "토"]
  
  typealias TimeRange = (Int, Int)
  
  func isAvailable(rangePatterns: [String], targetPattern: String? = nil) -> Bool {
    var target: String
    if let _ = targetPattern {
      target = targetPattern!
    } else {
      target = convertToTargetPattern(date: Date())
    }
    let timeRanges = rangePatterns.map{ convertToTimeRange(rangePattern: $0) }
    let targetMin: Int = convertToMin(targetPattern: target)
    for timeRange in timeRanges {
      if isContained(range: timeRange, targetMin: targetMin) {
        return true
      }
    }
    return false
  }
  
  func isContained(range: TimeRange, targetMin: Int) -> Bool {
    let startTime = range.0
    let endTime = range.1
    if targetMin >= startTime && targetMin < endTime {
      return true
    }
    return false
  }
  
  func convertToTimeRange(rangePattern: String) -> TimeRange {
    let weekDayAndTime = rangePattern.components(separatedBy: " ")
    let weekDay = weekDayAndTime[0].prefix(1)
    let timeArr = weekDayAndTime[1].components(separatedBy: "~")
    let startTime = timeArr[0]
    let endTime = timeArr[1]
    var weekDayIndex: Int = 0
    for i in 0..<days.count {
      if days[i] == weekDay {
        weekDayIndex = i
        break
      }
    }
    return (weekDayIndex * 24 * 60 + convertToMin(hourAndMin: startTime),
            weekDayIndex * 24 * 60 + convertToMin(hourAndMin: endTime))
  }
  
  func convertToMin(hourAndMin: String) -> Int {
    let hourAndMin = hourAndMin.components(separatedBy: ":")
    let hour = Int(hourAndMin[0])
    let min = Int(hourAndMin[1])
    return hour! * 60 + min!
  }
  
  func convertToMin(targetPattern: String) -> Int {
    let weekDayAndTime = targetPattern.components(separatedBy: " ")
    let weekDay = weekDayAndTime[0].prefix(1)
    let targetTime = weekDayAndTime[1]
    
    var weekDayIndex: Int = -1
    for i in 0..<days.count {
      if days[i] == weekDay {
        weekDayIndex = i
        break
      }
    }
    if weekDayIndex == -1 {
      return -1
    }
    return weekDayIndex * 24 * 60 + convertToMin(hourAndMin: targetTime)
  }
  
  func convertToTargetPattern(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "EEEE HH:mm"
    return dateFormatter.string(from: date)
  }
}
