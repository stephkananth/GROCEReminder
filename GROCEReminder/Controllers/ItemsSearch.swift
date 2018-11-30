//
//  ItemsSearch.swift
//  GROCEReminder
//
//  Created by Juliann Fields on 11/30/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UISearch extension
extension ItemsSearch: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

class ItemsSearch: UIViewController, UITableViewDataSource, UITableViewDelegate, AddItemControllerDelegate {
  
  let items = ShelfItems()
  let viewModel = ItemsSearchViewModel()
  let searchController = UISearchController(searchResultsController: nil)
  
  @IBOutlet var tableView: UITableView!
  
  // MARK: - viewDidLoad, WillAppear
  override func viewDidLoad() {
    super.viewDidLoad()
    // register the nib
    let cellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "cell")
    // set up the search bar (method below)
    setupSearchBar()
    // get the data for the table
    viewModel.refresh { [unowned self] in
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: true)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
    
    // MARK: - Table View
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.name?.text = viewModel.titleForRowAtIndexPath(indexPath)
        cell.category?.text = viewModel.summaryForRowAtIndexPath(indexPath)
        return cell
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "addSearchItem", sender: indexPath)
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let addItemVC = segue.destination as? AddItemController,
//      let indexPath = sender as? IndexPath {
//      addItemVC.viewModel = viewModel.detailViewModelForRowAtIndexPath(indexPath)
//    }
    if segue.identifier == "addSearchItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! AddItemController
      let indexPath = sender as? IndexPath
      controller.viewModel = viewModel.detailViewModelForRowAtIndexPath(indexPath!)
      controller.delegate = self
    }
  }
  
  
  // MARK: - Search Methods
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
  }
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    viewModel.updateFiltering(searchText)
    tableView.reloadData()
  }
  
  
  // MARK: - Delegate protocols
  func addItemControllerDidCancel(controller: AddItemController) {
    dismiss(animated: true, completion: nil)
  }
  
  func addItemController(controller: AddItemController, didFinishAddingItem item: Item) {
    dismiss(animated: true, completion: nil)
    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "locationView") as UIViewController
    present(viewController, animated: true, completion: nil)
  }
  
}
