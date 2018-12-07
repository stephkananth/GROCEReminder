//
//  SearchTableViewCell.swift
//  GROCEReminder
//
//  Created by Juliann Fields on 11/30/18.
//  Copyright © 2018 Steph Ananth. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var category: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
