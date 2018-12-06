//
//  GROCEReminderTests.swift
//  GROCEReminderTests
//
//  Created by Steph Ananth on 12/6/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import XCTest
@testable import GROCEReminder

class GROCEReminderTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_Item() {
    let testItem = Item(name: "Milk", location: "fridge", purchase_date: Date(), expiration_date: Date())
    XCTAssert(testItem.name == "Milk")
    XCTAssert(testItem.location == "fridge")
  }
  
  func test_ShelfItem() {
    let testShelfItem = ShelfItem(name: "Milk", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    XCTAssert(testShelfItem.name == "Milk")
    XCTAssert(testShelfItem.category == "Dairy Products & Eggs")
    XCTAssert(testShelfItem.location == "fridge")
  }
}
