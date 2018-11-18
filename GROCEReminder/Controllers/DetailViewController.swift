//
//  DetailViewController.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/4/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift/42524767
extension Date
{
  func toString( dateFormat format  : String ) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}

class DetailViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var purchaseDateLabel: UILabel!
  @IBOutlet weak var expirationDateLabel: UILabel!
  
  var viewModel: ItemDetailViewModel?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  var detailItem: Item? {
    didSet {
      // Update the view.
      self.configureView()
    }
  }
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail: Item = self.detailItem {
      if let name = self.nameLabel {
        name.text = detail.name
        self.navigationItem.title = detail.name
      }
      if let location = self.locationLabel {
        location.text = detail.location
      }
      if let purchaseDate = self.purchaseDateLabel {
        purchaseDate.text = detail.purchaseDate.toString(dateFormat: "MM/dd/YY")
      }
      if let expirationDate = self.expirationDateLabel {
        expirationDate.text = detail.expirationDate.toString(dateFormat: "MM/dd/YY")
      }
    }
  }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
}
