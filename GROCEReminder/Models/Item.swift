//
//  Item.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/4/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation

class Item {
  
  // MARK: - Properties
  var expirationDate: Date
  var location: String
  var name: String
  var purchaseDate: Date
  
  // MARK: - General
  
  init(name: String, location: String, purchase_date: Date, expiration_date: Date) {
    self.name = name
    self.location = location
    self.purchaseDate = purchase_date
    self.expirationDate = expiration_date
  }
  
}
