//
//  ItemsViewModel.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/12/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import CoreData

class ItemsViewModel {
  var items = [Item]()
  
  //  let client = SearchItemsClient()
  
  func numberOfRows() -> Int {
    return self.items.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    if indexPath.row < self.numberOfRows() {
      return items[indexPath.row].name
    } else {
      return "error"
    }
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> ItemDetailViewModel {
    if indexPath.row < self.numberOfRows() {
      return ItemDetailViewModel(i: items[indexPath.row])
    } else {
      return ItemDetailViewModel(i: Item(name: "nil", location: "nil", purchase_date: Date(), expiration_date: Date()))
    }
  }
  
  func summaryForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    return items.description
  }
  
  //  func refresh(completion: @escaping () -> Void) {
  //    client.fetchItems { [unowned self] data in
  //
  //      // we need in this block a way for the parser to get an array of Item
  //      // objects (if they exist) and then set the items var in the view model to
  //      // those Item objects
  //
  //      if let items = self.parser.itemsFromSearchResponse(data) {
  //        self.items = items
  //      }
  //      completion()
  //    }
  //  }
}
