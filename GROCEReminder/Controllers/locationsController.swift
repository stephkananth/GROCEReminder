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
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    let controller = (segue.destination as! ItemsController)
    // set location for list
    if segue.identifier == "showFridge" {
        controller.detailItem = "fridge"
    }
    else if segue.identifier == "showPantry" {
      controller.detailItem = "pantry"
    }
    else if segue.identifier == "showFreezer" {
      controller.detailItem = "freezer"
    }
    else if segue.identifier == "showSpice" {
      controller.detailItem = "spice"
    }
    controller.hidesBottomBarWhenPushed = true
  }
}
