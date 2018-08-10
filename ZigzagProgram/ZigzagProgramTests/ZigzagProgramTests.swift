//
//  ZigzagProgramTests.swift
//  ZigzagProgramTests
//
//  Created by junwoo on 07/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import XCTest
@testable import ZigzagProgram

class ZigzagProgramTests: XCTestCase {
  
  let alterDateFormat = AlterDateFormat()
  let isAvailableTime = IsAvailableTime()
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  //test
  func testAlterDateFormat() {
    
    let result1 = alterDateFormat.addSecAndConvertToTwentyFour(currentTime: "PM 01:00:00", N: 10)
    XCTAssertEqual("13:00:10", result1)
    
    let result2 = alterDateFormat.addSecAndConvertToTwentyFour(currentTime: "PM 11:59:59", N: 1)
    XCTAssertEqual("00:00:00", result2)
    
    let result3 = alterDateFormat.addSecAndConvertToTwentyFour(currentTime: "AM 12:10:00", N: 40)
    XCTAssertEqual("00:10:40", result3)
    
    let result4 = alterDateFormat.addSecAndConvertToTwentyFour(currentTime: "AM 05:24:03", N: 102392)
    XCTAssertEqual("09:50:35", result4)
  }
  
  func testIsAvailableTime() {
    let case1: [String] = ["월 09:00~18:00", "화 09:00~18:00", "수 09:00~18:00",
                           "목 09:00~18:00", "금 09:00~18:00", "토 09:00~13:00"]
    let case2: [String] = ["토 09:00~18:00", "일 09:00~18:00"]
    let case3: [String] = ["월 09:00~13:00", "월 14:00~18:00", "화 09:00~13:00",
                           "화 14:00~18:00", "수 09:00~13:00", "수 14:00~18:00",
                           "목 09:00~13:00", "목 14:00~18:00"]
    
    let result1 = isAvailableTime.isAvailable(rangePatterns: case1,
                                              targetPattern: "화 09:00")
    XCTAssertTrue(result1)
    
    let result2 = isAvailableTime.isAvailable(rangePatterns: case2,
                                              targetPattern: "토요일 18:00")
    XCTAssertFalse(result2)
    
    let result3 = isAvailableTime.isAvailable(rangePatterns: case3,
                                              targetPattern: "월 13:30")
    XCTAssertFalse(result3)
  }
}
