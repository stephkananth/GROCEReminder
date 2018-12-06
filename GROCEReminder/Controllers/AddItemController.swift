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
  
  // Pickers
  var pickerData: [[String]] = [[String]]()
  private var expPicker: UIDatePicker?
  private var datePicker: UIDatePicker?
  private var expiration: Date?
  private var date: Date!
  
  weak var delegate: AddItemControllerDelegate?
  
  var detailItem: String?
  var dateHelper = DateHelper()
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
    case (_, -1, -1):
      location = "pantry"
      shelfLifeMetricLabel.text = si.pantry_metric
      shelfLifeAmtLabel.text = String(si.pantry_length)
      row1 = si.pantry_length
    case (-1, _, -1):
      location = "freezer"
      shelfLifeMetricLabel.text = si.freeze_metric
      shelfLifeAmtLabel.text = String(si.freeze_length)
      row1 = si.freeze_length
    case (-1, -1, _):
      location = "fridge"
      shelfLifeMetricLabel.text = si.fridge_metric
      shelfLifeAmtLabel.text = String(si.fridge_length)
      row1 = si.fridge_length
    case (_, _, _):
      location = ""
      row1 = 0
    }
    switch shelfLifeMetricLabel.text! {
    case "Days":
      row2 = 0
    case "weeks":
      row2 = 1
    case "Months":
      row2 = 2
    case "Years":
      row2 = 3
    default:
      row2 = 0
    }
    shelfLife!.selectRow(row1, inComponent: 0, animated: true)
    shelfLife!.selectRow(row2, inComponent: 0, animated: true)
  }
  
  func selectLocation(loc: String) {
    switch location
    {
    case "freezer":
      location = "Freezer"
    case "pantry":
      location = "Pantry"
    case "spice":
      location = "Spice Rack"
    case "fridge":
      location = "Refrigerator"
    default:
      location = ""
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
  }
  
  @objc func dateChanged(datePicker: UIDatePicker) {
    purchaseDateField.text = dateHelper.string(from: datePicker.date)
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
