//
//  locationsController.swift
//  GROCEReminder
//
//  Created by Juliann Fields on 11/28/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class locationsController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var fridgeButton: UIButton!
  @IBOutlet weak var pantryButton: UIButton!
  @IBOutlet weak var freezerButton: UIButton!
  @IBOutlet weak var spiceButton: UIButton!
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setToolbarHidden(false, animated: false)
    self.navigationController?.toolbar.barTintColor = UIColor.black.withAlphaComponent(0.5)
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // show top bar and hide bottom bar
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    if segue.identifier == "newItem" {
      let controller = (segue.destination as! ItemsSearch)
      controller.hidesBottomBarWhenPushed = true
    }
    else if segue.identifier == "showFridge" {
      let controller = (segue.destination as! ItemsController)
      controller.detailItem = "fridge"
      controller.hidesBottomBarWhenPushed = true
    }
    else if segue.identifier == "showPantry" {
      let controller = (segue.destination as! ItemsController)
      controller.detailItem = "pantry"
      controller.hidesBottomBarWhenPushed = true
    }
    else if segue.identifier == "showFreezer" {
      let controller = (segue.destination as! ItemsController)
      controller.detailItem = "freezer"
      controller.hidesBottomBarWhenPushed = true
    }
    else if segue.identifier == "showSpice" {
      let controller = (segue.destination as! ItemsController)
      controller.detailItem = "spice"
      controller.hidesBottomBarWhenPushed = true
    }
  }
}
