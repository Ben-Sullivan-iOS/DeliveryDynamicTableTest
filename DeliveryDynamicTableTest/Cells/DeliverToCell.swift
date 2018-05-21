//
//  DeliverToCell.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

class DeliverToCell: UITableViewCell {
  
  @IBOutlet weak var notesText: UILabel!
  @IBOutlet weak var instructionsView: UIView!
  @IBOutlet weak var addDriverBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var driverButton: UIButton!
  @IBOutlet weak var addDriverButton: UIButton!
  
  weak var delegate: DeliveryTableViewControllerDelegate?
  
  @IBAction func addInstructionsButtonTapped(_ sender: Any) {
    
    addDriverBottomConstraint.isActive = false
    addDriverButton.isHidden = true
    notesText.isHidden = false
    instructionsView.isHidden = false
    
    delegate?.reloadData()
  }
  
}
