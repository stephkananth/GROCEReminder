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
  func toString( dateFormat format: String ) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}

class DetailViewController: UIViewController {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var purchaseDateLabel: UILabel!
  @IBOutlet weak var expirationDateLabel: UILabel!
  
  @IBOutlet weak var fridgeButton: UIButton!
  @IBOutlet weak var freezerButton: UIButton!
  @IBOutlet weak var pantryButton: UIButton!
  @IBOutlet weak var spiceButton: UIButton!
    
  
  var viewModel: ItemDetailViewModel?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
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
      // set title to name
      self.title = detail.name
      // set details
      if let location = self.locationLabel {
        location.text = detail.location
        setLocationIcons(loc: detail.location)
      }
      if let purchaseDate = self.purchaseDateLabel {
        purchaseDate.text = detail.purchaseDate.toString(dateFormat: "MM/dd/YY")
      }
      if let expirationDate = self.expirationDateLabel {
        expirationDate.text = detail.expirationDate.toString(dateFormat: "MM/dd/YY")
      }
    }
  }
  
  func setLocationIcons( loc: String ) {
    switch loc {
      case "fridge":
        self.fridgeButton.isSelected = true
        self.freezerButton.isEnabled = false
        self.pantryButton.isEnabled = false
        self.spiceButton.isEnabled = false
        break
      case "freezer":
        self.freezerButton.isSelected = true
        self.fridgeButton.isEnabled = false
        self.pantryButton.isEnabled = false
        self.spiceButton.isEnabled = false
        break
      case "pantry":
        self.pantryButton.isSelected = true
        self.freezerButton.isEnabled = false
        self.fridgeButton.isEnabled = false
        self.spiceButton.isEnabled = false
        break
      case "spice":
        self.spiceButton.isSelected = true
        self.freezerButton.isEnabled = false
        self.pantryButton.isEnabled = false
        self.fridgeButton.isEnabled = false
        break
      default:
        break
    }
  }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPress))
      self.navigationItem.rightBarButtonItem = button
      self.configureView()
    }
    
    @objc func editButtonPress() {
        
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
}
