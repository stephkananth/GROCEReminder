//
//  DateHelper.swift
//  GROCEReminder
//
//  Created by Juliann Fields on 11/30/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation

public class DateHelper {
  
  let dateFormatter = DateFormatter()
  
  init() {
    dateFormatter.dateFormat = "MM/dd/yy"
  }
  
  public func expDays(len: Int, metric: String) -> Int {
    var metricLen: Int
    
    switch metric {
      case "Days":
        metricLen = 1
      case "Weeks":
        metricLen = 7
      case "Months":
        metricLen = 30
      case "Years":
        metricLen = 365
      default:
        metricLen = 0
    }
    return len * metricLen
  }
  
  public func expDate(item: ShelfItem, date: Date) -> Date {
    var days = 0
    switch item.location {
      case "fridge":
        days = expDays(len: item.fridge_length, metric: item.fridge_metric)
      case "freezer":
        days = expDays(len: item.fridge_length, metric: item.fridge_metric)
      case "pantry":
        days = expDays(len: item.fridge_length, metric: item.fridge_metric)
      default:
        days = 0
    }
    return Calendar.current.date(byAdding: .day, value: days, to: date)!
  }
  
  public func string(from date: Date) -> String {
    return dateFormatter.string(from: date)
  }
  
//  public func toDate(date: String) -> Date {
//
//  }
}
