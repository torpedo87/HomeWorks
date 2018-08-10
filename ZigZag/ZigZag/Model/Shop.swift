//
//  Shop.swift
//  ZigZag
//
//  Created by junwoo on 05/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

struct Shop: Codable {
  let rank: Int
  let name: String
  let url: String
  let styles: String
  let ages: [Int]
  static let generation = ["10대", "20대초반", "20대중반", "20대후반", "30대초반",
                           "30대중반", "30대후반"]
  
  private enum CodingKeys: String, CodingKey {
    case rank = "0"
    case name = "n"
    case url = "u"
    case styles = "S"
    case ages = "A"
  }
  
  func getStyleArr() -> [String] {
    return styles.components(separatedBy: ",")
  }
  
  func convertToGeneration() -> String {
    var result: [String] = []
    if ages[0] == 1 {
      result.append("10대")
    }
    if ages[1...3].contains(1) {
      result.append("20대")
    }
    if ages[4...6].contains(1) {
      result.append("30대")
    }
    return result.joined(separator: " ")
  }
  
  func isMatchedByAge(selectedIndex: [Int]) -> Bool {
    for index in selectedIndex {
      if self.ages[index] == 1 {
        return true
      }
    }
    return false
  }
  
  func styleMatchCount(selectedStyle: [String]) -> Int {
    let styleArr = self.styles.components(separatedBy: ",")
    var rank: Int = 0
    for style in styleArr {
      if selectedStyle.contains(style) {
        rank += 1
      }
    }
    return rank
  }
}
