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
  
  func testItem() {
    let test_item = Item(name: "Milk", location: "fridge", purchase_date: Date(), expiration_date: Date())
    XCTAssert(test_item.name == "Milk")
    XCTAssert(test_item.location == "fridge")
  }
  
}
