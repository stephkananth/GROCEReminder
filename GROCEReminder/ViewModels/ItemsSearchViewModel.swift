//
//  itemsSearchViewModel.swift
//  GROCEReminder
//
//  Created by Juliann Fields on 11/30/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation

class ItemsSearchViewModel {
  var items = [ShelfItem]()
  var filteredItems = [ShelfItem]()
  
  func refresh(_ completion: @escaping () -> Void) {
    self.items = ShelfItems.allItems()
    completion()
  }
  
  func numberOfRows() -> Int {
    if filteredItems.isEmpty {
      return items.count
    } else {
      return filteredItems.count
    }
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < items.count else {
      return ""
    }
    if filteredItems.isEmpty {
      return items[indexPath.row].name
    } else {
      return filteredItems[indexPath.row].name
    }
  }
  
  func summaryForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < items.count else {
      return ""
    }
    if filteredItems.isEmpty {
      return items[indexPath.row].category
    } else {
      return filteredItems[indexPath.row].category
    }
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> ItemDetailViewModel {
    let item = (filteredItems.isEmpty ? items[indexPath.row] : filteredItems[indexPath.row])
    return ItemDetailViewModel(shelfItem: item)
  }
  
  func updateFiltering(_ searchText: String) -> Void {
    filteredItems = self.items.filter { repo in
      return repo.name.lowercased().contains(searchText.lowercased())
    }
  }
}
