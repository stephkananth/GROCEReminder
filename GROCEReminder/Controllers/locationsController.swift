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
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showFridge" {
      (segue.destination as! ItemsController).detailItem = "fridge"
    } else if segue.identifier == "showPantry" {
      (segue.destination as! ItemsController).detailItem = "pantry"
    } else if segue.identifier == "showFreezer" {
      (segue.destination as! ItemsController).detailItem = "freezer"
    } else if segue.identifier == "showSpice" {
      (segue.destination as! ItemsController).detailItem = "spice"
    }
  }
}
