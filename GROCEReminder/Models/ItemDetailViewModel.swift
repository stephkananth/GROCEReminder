//
//  ItemDetailViewModel.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/12/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import CoreData

class ItemDetailViewModel {
  var item: Item
  
  init(i: Item) {
    self.item = i
  }
  
  func name() -> String {
    return item.name
  }
  
  func expirationDate() -> Date {
    return item.expirationDate
  }
}
