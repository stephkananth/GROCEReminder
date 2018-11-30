//
//  ShelfLife.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/29/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation

let categories = [
  1: "Baby Food",
  2: "Baked Goods",
  3: "Baked Goods",
  4: "Baked Goods",
  5: "Beverages",
  6: "Condiments, Sauces & Canned Goods",
  7: "Dairy Products & Eggs",
  8: "Food Purchased Frozen",
  9: "Grains, Beans & Pasta",
  10: "Meat",
  11: "Meat",
  12: "Meat",
  13: "Meat",
  14: "Meat",
  15: "Meat",
  16: "Meat",
  17: "Meat",
  18: "Produce",
  19: "Produce",
  20: "Seafood",
  21: "Seafood",
  22: "Seafood",
  23: "Shelf Stable Foods",
  24: "Vegetarian Proteins",
  25: "Deli & Prepared Foods"
]

public struct ShelfItem {
  var name: String
  var category: String
  var pantry_length: Int
  var pantry_metric: String
  var fridge_length: Int
  var fridge_metric: String
  var freeze_length: Int
  var freeze_metric: String
  var location: String
  
  init(name: String, category_num: Int, pantry_length: Int, pantry_metric: String, fridge_length: Int, fridge_metric: String, freeze_length: Int, freeze_metric: String) {
    self.name = name
    self.category = categories[category_num] ?? "Other"
    self.pantry_length = pantry_length
    self.pantry_metric = pantry_metric
    self.fridge_length = fridge_length
    self.fridge_metric = fridge_metric
    self.freeze_length = freeze_length
    self.freeze_metric = freeze_metric
    
    switch (self.pantry_length, self.freeze_length, self.fridge_length) {
    case (_, -1, -1):
      self.location = "pantry"
    case (-1, _, -1):
      self.location = "freezer"
    case (-1, -1, _):
      self.location = "fridge"
    case (_, _, _):
      self.location = ""
    }
  }
  
}
