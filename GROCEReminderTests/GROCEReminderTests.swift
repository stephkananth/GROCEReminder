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
  
  // Testing ../GROCEReminder/Models/Item.swift
  func test_Item() {
    let testItem = Item(name: "Milk", location: "fridge", purchase_date: Date(), expiration_date: Date())
    XCTAssert(testItem.name == "Milk")
    XCTAssert(testItem.location == "fridge")
  }
  
  // Testing ../GROCEReminder/Models/ShelfItem.swift
  func test_ShelfItem() {
    let testShelfItem = ShelfItem(name: "Milk", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    XCTAssert(testShelfItem.name == "Milk")
    XCTAssert(testShelfItem.category == "Dairy Products & Eggs")
    XCTAssert(testShelfItem.location == "fridge")
  }
  
  // Testing ../GROCEReminder/ViewModels/ItemDetailViewModel.swift
  func test_ItemDetailViewModel() {
    let testShelfItem = ShelfItem(name: "Milk", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    _ = ItemDetailViewModel(shelfItem: testShelfItem)
  }
  
  // Testing ../GROCEReminder/ViewModels/ItemsSearchViewModel.swift
  func test_numberOfRows() {
    let items = [ShelfItem(name: "Milk", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: ""), ShelfItem(name: "Milk", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: ""), ShelfItem(name: "Milk", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")]
    let viewModel = ItemsSearchViewModel()
    viewModel.items = items
    XCTAssert(viewModel.numberOfRows() == 3)
  }
  
  func test_titleForRowAtIndexPath() {
    let item1 = ShelfItem(name: "Milk1", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let item2 = ShelfItem(name: "Milk2", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let items = [item1, item2]
    let viewModel = ItemsSearchViewModel()
    viewModel.items = items
    let indexPath1 = IndexPath(row: 0, section: 0)
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath1), "Milk1")
    let indexPath2 = IndexPath(row: 1, section: 0)
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath2), "Milk2")
    let indexPath3 = IndexPath(row: 99, section: 99)
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath3), "")
  }
  
  func test_summaryForRowAtIndexPath() {
    let item1 = ShelfItem(name: "Milk1", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let item2 = ShelfItem(name: "Milk2", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let items = [item1, item2]
    let viewModel = ItemsSearchViewModel()
    viewModel.items = items
    let indexPath1 = IndexPath(row: 0, section: 0)
    XCTAssertEqual(viewModel.summaryForRowAtIndexPath(indexPath1), "Dairy Products & Eggs")
    let indexPath2 = IndexPath(row: 1, section: 0)
    XCTAssertEqual(viewModel.summaryForRowAtIndexPath(indexPath2), "Dairy Products & Eggs")
  }
  
  func test_detailViewModelForRowAtIndexPath() {
    let item1 = ShelfItem(name: "Milk1", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let item2 = ShelfItem(name: "Milk2", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let items = [item1, item2]
    let viewModel = ItemsSearchViewModel()
    viewModel.items = items
    let indexPath1 = IndexPath(row: 0, section: 0)
    XCTAssertNotNil(viewModel.detailViewModelForRowAtIndexPath(indexPath1))
  }
  
  func test_updateFiltering() {
    let item1 = ShelfItem(name: "Milk1", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let item2 = ShelfItem(name: "Milk2", category_num: 7, pantry_length: -1, pantry_metric: "", fridge_length: 2, fridge_metric: "Weeks", freeze_length: -1, freeze_metric: "")
    let items = [item1, item2]
    let viewModel = ItemsSearchViewModel()
    viewModel.items = items
    viewModel.updateFiltering("m")
    XCTAssertNotNil(viewModel.filteredItems)
  }
}
