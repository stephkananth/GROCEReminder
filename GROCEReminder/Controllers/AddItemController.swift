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
  
  private var location: String? = ""
  private var category: String? = "N/A"
  
  // Pickers
  var pickerData: [[String]] = [[String]]()
  private var expPicker: UIDatePicker?
  private var datePicker: UIDatePicker?
  private var expiration: Date?
  private var date: Date!
  
  weak var delegate: AddItemControllerDelegate?
  
  var detailItem: String?
  var dateHelper = DateHelper()
  //  var calHelpter =
  var viewModel: ItemDetailViewModel?
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail: String = self.detailItem {
      selectLocation(loc: detail)
      setLocation()
    }
    if let vm = self.viewModel {
      let si = vm.shelfItem
      nameField.text = si.name
      setMetrics(si:si)
      category = si.category
      expiration = dateHelper.expDate( location: location!, item: si, date: date )
      expirationDateField.text = dateHelper.string(from: expiration!)
      print(expirationDateField.text!)
      setLocation()
    }
  }
  
  func setMetrics(si:ShelfItem) {
    var row1: Int
    var row2: Int
    switch (si.pantry_length, si.freeze_length, si.fridge_length) {
    case (-1, -1, -1):
      location = ""
      row1 = 0
      break
    case (_, -1, -1):
      location = "pantry"
      shelfLifeMetricLabel.text = si.pantry_metric
      shelfLifeAmtLabel.text = String(si.pantry_length)
      row1 = si.pantry_length
      break
    case (-1, _, -1):
      location = "freezer"
      shelfLifeMetricLabel.text = si.freeze_metric
      shelfLifeAmtLabel.text = String(si.freeze_length)
      row1 = si.freeze_length
      break
    case (-1, -1, _):
      location = "fridge"
      shelfLifeMetricLabel.text = si.fridge_metric
      shelfLifeAmtLabel.text = String(si.fridge_length)
      row1 = si.fridge_length
      break
    case (_, _, _):
      location = ""
      row1 = 0
    }
    switch shelfLifeMetricLabel.text! {
    case "Days":
      row2 = 0
      break
    case "weeks":
      row2 = 1
      break
    case "Months":
      row2 = 2
      break
    case "Years":
      row2 = 3
      break
    default:
      row2 = 0
      break
    }
    shelfLife!.selectRow(row1, inComponent: 0, animated: true)
    shelfLife!.selectRow(row2, inComponent: 1, animated: true)
    shelfLifeAmtLabel.text = pickerData[0][row1]
    shelfLifeMetricLabel.text = pickerData[1][row2]
  }
  
  func selectLocation(loc: String) {
    switch loc
    {
    case "freezer":
      location = "Freezer"
      break
    case "pantry":
      location = "Pantry"
      break
    case "spice":
      location = "Spice Rack"
      break
    case "fridge":
      location = "Refrigerator"
      break
    default:
      location = ""
      break
    }
  }
  
  func setLocation() {
    switch location
    {
    case "freezer":
      location = "Freezer"
      freezer.setImage( UIImage (named: "icon_freezer_select"), for: .normal)
      fridge.setImage( UIImage (named: "icon_fridge"), for: .normal)
      spiceRack.setImage( UIImage (named: "icon_seasoning"), for: .normal)
      pantry.setImage( UIImage (named: "icon_pantry"), for: .normal)
      break
    case "pantry":
      location = "Pantry"
      pantry.setImage( UIImage (named: "icon_pantry_select"), for: .normal)
      fridge.setImage( UIImage (named: "icon_fridge"), for: .normal)
      spiceRack.setImage( UIImage (named: "icon_seasoning"), for: .normal)
      freezer.setImage( UIImage (named: "icon_freezer"), for: .normal)
      break
    case "spice":
      location = "Spice Rack"
      spiceRack.setImage( UIImage (named: "icon_seasoning_select"), for: .normal)
      freezer.setImage( UIImage (named: "icon_freezer"), for: .normal)
      fridge.setImage( UIImage (named: "icon_fridge"), for: .normal)
      pantry.setImage( UIImage (named: "icon_pantry"), for: .normal)
      break
    case "fridge":
      location = "Refrigerator"
      fridge.setImage( UIImage (named: "icon_fridge_select"), for: .normal)
      spiceRack.setImage( UIImage (named: "icon_seasoning"), for: .normal)
      freezer.setImage( UIImage (named: "icon_freezer"), for: .normal)
      pantry.setImage( UIImage (named: "icon_pantry"), for: .normal)
      break
    default:
      break
    }
  }
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddItemController.viewTapped(gestureRecognizer:)) )
    view.addGestureRecognizer(tapGesture)
    
    date = Date()
    purchaseDateField.text = dateHelper.string(from: date)
    
    configurePickers()
    self.configureView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    expirationDateField.text = dateHelper.string(from: datePicker.date)
    expiration = datePicker.date
    updateShelfLife()
  }
  
  @objc func dateChanged(datePicker: UIDatePicker) {
    purchaseDateField.text = dateHelper.string(from: datePicker.date)
    date = datePicker.date
    let days = dateHelper.expDays(len: Int(shelfLifeAmtLabel.text!)!, metric: shelfLifeMetricLabel.text!)
    let newExp = Calendar.current.date(byAdding: .day, value: days, to: date!)
    expPicker?.date = newExp!
    expiration = newExp
    expirationDateField.text = dateHelper.string(from: expiration!)
  }
  
  @objc func viewTapped(gestureRecognizer: UIGestureRecognizer) {
    view.endEditing(true)
    if !(shelfLife?.isHidden)! { shelfLife?.isHidden = true }
  }
  
  func updateShelfLife() {
    let days = expiration!.days(from: date)+1
    let row1: Int
    var row2: Int
    
    switch days {
    case _ where (days > 7 && days < 30):// % 7 == 0): // weeks
      row1 = days/7
      row2 = 1
      break
    case _ where (days >= 30 && days < 365)://% 30 == 0): // months
      row1 = days/30
      row2 = 2
      break
    case _ where (days >= 365): //% 365 == 0): // years
      row1 = days/365
      row2 = 3
      break
    default: // days
      row1 = days
      row2 = 0
      break
    }
    
    shelfLife!.selectRow(row1, inComponent: 0, animated: false)
    shelfLife!.selectRow(row2, inComponent: 1, animated: false)
    shelfLifeAmtLabel.text = pickerData[0][row1]
    shelfLifeMetricLabel.text = pickerData[1][row2]
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
    let cat:String = self.category!
    let item = Item(name: name, location: location, purchase_date: purchase_date, expiration_date: expiration_date, category: cat)
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
    newItem.setValue(item.category, forKey: "category")
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
    let days = dateHelper.expDays(len: Int(shelfLifeAmtLabel.text!)!, metric: shelfLifeMetricLabel.text!)
    let newExp = Calendar.current.date(byAdding: .day, value: days, to: date!)
    expPicker?.date = newExp!
    expiration = newExp
    expirationDateField.text = dateHelper.string(from: expiration!)
  }
  
}
