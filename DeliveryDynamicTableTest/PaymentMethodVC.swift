//
//  PaymentMethodVC.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

class PaymentMethodVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    let paymentMethodNib = UINib(nibName: "PaymentMethodCell", bundle: .main)
//    tableView.register(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tableView.reloadData()
  }
  
}

extension PaymentMethodVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "bro"
    cell.backgroundColor = .blue
    return cell
  }
}
