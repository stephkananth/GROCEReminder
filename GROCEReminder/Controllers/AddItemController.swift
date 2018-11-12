//
//  AddItemController.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/4/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK: Protocol Methods

protocol AddItemControllerDelegate: class {
  func addItemControllerDidCancel(controller: AddItemController)
  
  func addItemController(controller: AddItemController, didFinishAddingItem item: Item)
}

// MARK: - AddItemController

class AddItemController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // MARK: - Outlets
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var expirationDateField: UIDatePicker!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var purchaseDateField: UIDatePicker!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  
  // MARK: - Properties
  weak var delegate: AddItemControllerDelegate?
  
  func saveItem(item: Item){
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    // Specifically select the People entity to save this object to
    let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
    let newItem = NSManagedObject(entity: entity!, insertInto: context)
    // Set values one at a time and save
    newItem.setValue(item.name, forKey: "name")
    newItem.setValue(item.location, forKey: "location")
    newItem.setValue(item.expirationDate, forKey: "expiration_date")
    newItem.setValue(item.purchaseDate, forKey: "purchase_date")
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
  }
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    // doneBarButton.isEnabled = false
    //    if let nameText = nameField.text {
    //      doneBarButton.isEnabled = (nameText != "")
    //    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameField.becomeFirstResponder()
    //    doneBarButton.isEnabled = false
  }
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.addItemControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    let name:String = nameField.text!
    let location:String = locationField.text!
    let purchase_date:Date = purchaseDateField.date
    let expiration_date:Date = expirationDateField.date
    let item = Item(name: name, location: location, purchase_date: purchase_date, expiration_date: expiration_date)
    //    item.name = nameField.text!
    //    item.expirationDate = expirationDateField.date
    //    item.location = locationField.text!
    //    item.purchaseDate = purchaseDateField.date
    saveItem(item: item)
    if item.name.count > 0 {
      delegate?.addItemController(controller: self, didFinishAddingItem: item)
    }
  }
  
  // MARK: - Table View
  
  func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
}
