//
//  ItemsController.swift
//  ItemsLite
//  Copyright © 2018 Larry Heimann. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ItemsController: UITableViewController, AddItemControllerDelegate {
  
  // MARK: - Properties
  var items = [Item]()
  var dataManager = DataManager()
  
  let viewModel = ItemsViewModel()
  let test = "Test"
  
  func loadItems(data: NSManagedObject){
    let name = data.value(forKey: "name") as! String
    let expirationDate = (data.value(forKey: "expiration_date") as! Date)
    let purchaseDate = (data.value(forKey: "purchase_date") as! Date)
    let location = (data.value(forKey: "location") as! String)
    let newItem = Item(name: name, location: location, purchase_date: purchaseDate, expiration_date: expirationDate)
    items.append(newItem)
  }
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "cell")
    //    cellNib.name?.text = viewModel.nameForRowAtIndexPath(indexPath)
    //    cellNib.expiration_date?.text = viewModel.dateForRowAtIndexPath(indexPath)
    
    
    // Again set up the stack to interface with CoreData
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        self.loadItems(data: data)
        print(data.value(forKey: "name") as! String)
      }
    } catch {
      print("Failed")
    }
    
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem
    dataManager.loadItems()
    items = dataManager.items
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let item = items[indexPath.row]
        (segue.destination as! DetailViewController).detailItem = item
      }
    } else if segue.identifier == "addItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! AddItemController
      //controller.doneBarButton.isEnabled = false
      controller.delegate = self
    }
  }
  
  // MARK: - Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
    
    let item = items[indexPath.row]
    cell.textLabel!.text = item.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
          // if the item we are deleting is the same as this one in CoreData { }
          context.delete(data)
          try context.save()
        }
      } catch {
        print("Failed")
      }
      items.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array,
      // and add a new row to the table view. However, not strictly needed here
      // given the segue automatically goes to add item.
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showDetail", sender: tableView)
  }
  
  // MARK: - Delegate protocols
  
  func addItemControllerDidCancel(controller: AddItemController) {
    dismiss(animated: true, completion: nil)
  }
  
  func addItemController(controller: AddItemController, didFinishAddingItem item: Item) {
    let newRowIndex = items.count
    
    items.append(item)
    
    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    
    dismiss(animated: true, completion: nil)
  }
}

