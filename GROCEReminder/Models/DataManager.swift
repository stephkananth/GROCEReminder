//
//  DataManager.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/4/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation

// MARK: - String Extension

extension String {
  // recreating a function that String class no longer supports in Swift 2.3
  // but still exists in the NSString class. (This trick is useful in other
  // contexts as well when moving between NS classes and Swift counterparts.)
  
  /**
   Returns a new string made by appending to the receiver a given string.  In this case, a new string
   made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
   
   - parameter aPath: The path component to append to the receiver. (String)
   - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
   
   */
  func stringByAppendingPathComponent(aPath: String) -> String {
    let nsSt = self as NSString
    return nsSt.appendingPathComponent(aPath)
  }
}


// MARK: - Data Manager Class
class DataManager {
  
  // MARK: - General
  var items = [Item]()
  
  init() {
    loadItems()
    // print("Documents folder is \(documentsDirectory())\n")
    // print("Data file path is \(dataFilePath())")
  }
  
  
  // MARK: - Data Location Methods
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent(aPath: "Items.plist")
  }
  
  
  // MARK: - Saving & Loading Data
  
  /**
   Saves contact data to a plist.
   */
  func saveItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(items, forKey: "Items")
    archiver.finishEncoding()
    data.write(toFile: dataFilePath(), atomically: true)
  }
  
  /**
   Loads the data from a plist into items array.
   */
  func loadItems() {
    let path = dataFilePath()
    if FileManager.default.fileExists(atPath: path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
        self.items = unarchiver.decodeObject(forKey: "Items") as! [Item]
        unarchiver.finishDecoding()
      } else {
        print("\nFILE NOT FOUND AT: \(path)")
      }
    }
  }
  
  
}
