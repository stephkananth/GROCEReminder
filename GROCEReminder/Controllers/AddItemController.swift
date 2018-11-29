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

class AddItemController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
  // MARK: - Outlets
  
  // Fields
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var expirationDateField: UITextField!
  @IBOutlet weak var shelfLifeAmtLabel: UILabel!
  @IBOutlet weak var shelfLifeMetricLabel: UILabel!
  @IBOutlet weak var purchaseDateField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shelfLifeButton: UIButton!
  @IBOutlet weak var shelfLife: UIPickerView?
  
  // Locations
  @IBOutlet weak var spiceRack: UIButton!
  @IBOutlet weak var pantry: UIButton!
  @IBOutlet weak var freezer: UIButton!
  @IBOutlet weak var fridge: UIButton!
  
  private var location: String?
  
  // Pickers
  var pickerData: [[String]] = [[String]]()
  private var expPicker: UIDatePicker?
  private var datePicker: UIDatePicker?
  private var expiration: Date?
  private var date: Date?

  weak var delegate: AddItemControllerDelegate?
  
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddItemController.viewTapped(gestureRecognizer:)) )
    view.addGestureRecognizer(tapGesture)
    configurePickers()
  }
    
  func configurePickers() {
    // experation date picker
    expPicker = UIDatePicker()
    expPicker?.datePickerMode = .date
    expPicker?.addTarget(self, action: #selector(AddItemController.expChanged(datePicker:)), for: .valueChanged)
    expirationDateField.inputView = expPicker
    expiration = (expPicker?.date)!
    
    // purchase date picker
    datePicker = UIDatePicker()
    datePicker?.datePickerMode = .date
    datePicker?.addTarget(self, action: #selector(AddItemController.dateChanged(datePicker:)), for: .valueChanged)
    purchaseDateField.inputView = datePicker
    date = (datePicker?.date)!
    
    // shelf life length picker
    let metricData = ["Days", "Weeks", "Months", "Years"]
    var amountData = [String]()
    for i in 0 ... 100 { amountData.append(String(i)) }
    pickerData = [amountData, metricData]
    
    // Connect data:
    shelfLife?.isHidden = true
    shelfLife?.delegate = self
    shelfLife?.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameField.becomeFirstResponder()
  }
  
  
  // MARK: - Handlers
  @objc func expChanged(datePicker: UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    expirationDateField.text = dateFormatter.string(from: datePicker.date)
//    view.endEditing(true)
  }
  
  @objc func dateChanged(datePicker: UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    purchaseDateField.text = dateFormatter.string(from: datePicker.date)
//    view.endEditing(true)
  }
  
  @objc func viewTapped(gestureRecognizer: UIGestureRecognizer) {
    view.endEditing(true)
    shelfLife?.isHidden = true
  }
  
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.addItemControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    let name:String = nameField.text!
    let location:String = self.location!
    let purchase_date:Date = date!
    let expiration_date:Date = expiration!
    let item = Item(name: name, location: location, purchase_date: purchase_date, expiration_date: expiration_date)
    saveItem(item: item)
    print("HERE")
    delegate?.addItemController(controller: self, didFinishAddingItem: item)
  }
    
  @IBAction func shelfLifeButtonPress() {
    shelfLife?.isHidden = !(shelfLife?.isHidden)!
    view.endEditing(true)
  }
  
  @IBAction func locationButtonClick(_ sender: UIButton) {
    switch sender.tag
    {
      case 1:
        location = "freezer"
        freezer.setImage( UIImage (named: "icon_freezer_select"), for: .normal)
        fridge.setImage( UIImage (named: "icon_fridge"), for: .normal)
        spiceRack.setImage( UIImage (named: "icon_seasoning"), for: .normal)
        pantry.setImage( UIImage (named: "icon_pantry"), for: .normal)
        break
      case 2:
        location = "pantry"
        pantry.setImage( UIImage (named: "icon_pantry_select"), for: .normal)
        fridge.setImage( UIImage (named: "icon_fridge"), for: .normal)
        spiceRack.setImage( UIImage (named: "icon_seasoning"), for: .normal)
        freezer.setImage( UIImage (named: "icon_freezer"), for: .normal)
        break
      case 3:
        location = "spice"
        spiceRack.setImage( UIImage (named: "icon_seasoning_select"), for: .normal)
        freezer.setImage( UIImage (named: "icon_freezer"), for: .normal)
        fridge.setImage( UIImage (named: "icon_fridge"), for: .normal)
        pantry.setImage( UIImage (named: "icon_pantry"), for: .normal)
        break
      default:
        location = "fridge"
        fridge.setImage( UIImage (named: "icon_fridge_select"), for: .normal)
        spiceRack.setImage( UIImage (named: "icon_seasoning"), for: .normal)
        freezer.setImage( UIImage (named: "icon_freezer"), for: .normal)
        pantry.setImage( UIImage (named: "icon_pantry"), for: .normal)
        break
    }
  }
  
  func saveItem(item: Item) {
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    // Specifically select the People entity to save this object to
    let entity = NSEntityDescription.entity(forEntityName: "Food", in: context)
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
  
  // MARK: - Picker view Delegate
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      shelfLifeAmtLabel.text = pickerData[component][row]
    }
    else {
      shelfLifeMetricLabel.text = pickerData[component][row]
    }
  }
  
}
