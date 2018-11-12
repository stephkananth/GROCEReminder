//
//  Item.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/4/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import CoreData

class Item: NSObject, NSCoding {
  
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
    super.init()
  }
  
  // MARK: - Encoding
  
  // marking 'required' in case of subclassing, this init will be
  // required of the subclass (not really an issue here b/c not
  // subclassing; more for pedagogical purposes at this point)
  required init(coder aDecoder: NSCoder) {
    self.expirationDate = aDecoder.decodeObject(forKey: "expiration_date") as! Date
    self.location = aDecoder.decodeObject(forKey: "location") as! String
    self.name = aDecoder.decodeObject(forKey: "name") as! String
    self.purchaseDate = aDecoder.decodeObject(forKey: "purchase_date") as! Date
    super.init()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(expirationDate, forKey: "expiration_date")
    aCoder.encode(location, forKey: "location")
    aCoder.encode(name, forKey: "name")
    aCoder.encode(purchaseDate, forKey: "purchase_date")
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encode(expirationDate, forKey: "expiration_date")
    aCoder.encode(location, forKey: "location")
    aCoder.encode(name, forKey: "name")
    aCoder.encode(purchaseDate, forKey: "purchase_date")
  }
  
}
