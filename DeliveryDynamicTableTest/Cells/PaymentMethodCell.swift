//
//  PaymentMethodCell.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {
  
  @IBOutlet weak var tableView: UITableView!
  
  let cellTitles = ["Apple Pay", "AMEX", "VISA", "Etc..."]
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    tableView.dataSource = self
    tableView.delegate = self
    let nib = UINib(nibName: "PaymentMethodLabelCell", bundle: .main)
    tableView.register(nib, forCellReuseIdentifier: "paymentMethodLabelCell")
  }
}

extension PaymentMethodCell: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellTitles.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodLabelCell", for: indexPath) as! PaymentMethodLabelCell
    cell.selectionStyle = .none
    cell.paymentLabel.text = cellTitles[indexPath.row]
    return cell
  }
}

extension PaymentMethodCell: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath) as! PaymentMethodLabelCell
    
    UIView.animate(withDuration: 0.3) {
      
      cell.leadingConstraint.constant = 20
      
      cell.layoutIfNeeded()
    }
  }
}
