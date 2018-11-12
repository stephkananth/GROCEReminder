//
//  TableViewCell.swift
//  GROCEReminder
//
//  Created by Steph Ananth on 11/9/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var expirationDate: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
