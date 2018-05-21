//
//  ViewController.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

extension UITableViewCell {
  static var ID: String {
    return String(describing: self)
  }
}

protocol DeliveryTableViewControllerDelegate: class {
  var _tableView: UITableView? { get }
  func reloadData()
}

@objc protocol CheckoutVCType {
  @objc func insertCreateAccountRow()
}

class CheckoutVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var model: DeliveryViewModelType?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    model = DeliveryViewModel()
    model?.populateSectionHeaderTitles()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    tableView.backgroundColor = UIColor(white: 46.0 / 255.0, alpha: 1.0)
    
    view.backgroundColor = UIColor(white: 46.0 / 255.0, alpha: 1.0)
    
    let deliverToNib = UINib(nibName: "DeliverToCell", bundle: .main)
    tableView.register(deliverToNib, forCellReuseIdentifier: DeliverToCell.ID)
    
    let paymentMethodNib = UINib(nibName: "PaymentMethodCell", bundle: .main)
    tableView.register(paymentMethodNib, forCellReuseIdentifier: PaymentMethodCell.ID)
    
    let myDetailsNib = UINib(nibName: "MyDetailsCell", bundle: .main)
    tableView.register(myDetailsNib, forCellReuseIdentifier: MyDetailsCell.ID)
    
    let placeOrderNib = UINib(nibName: "PlaceOrderCell", bundle: .main)
    tableView.register(placeOrderNib, forCellReuseIdentifier: "placeOrderCell")
    
    let createAccountCell = UINib(nibName: "CreateAccountCell", bundle: .main)
    tableView.register(createAccountCell, forCellReuseIdentifier: CreateAccountCell.ID)
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //  Prevents sticky headers, there must be a native way?!
    let dummyViewHeight = CGFloat(40)
    self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
  }
  
}

extension CheckoutVC: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return model?.sectionCount ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model?.numberOfRows(inSection: section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return model?.cellForRow(indexPath: indexPath, delegate: self) ?? UITableViewCell()
  }
  
}

extension CheckoutVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model?.headerHeight(forSection: section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return model?.viewForHeader(inSection: section, inView: view, delegate: self)
  }

}

extension CheckoutVC: DeliveryTableViewControllerDelegate, CheckoutVCType {
  
  var _tableView: UITableView? {
    return tableView
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  @objc func insertCreateAccountRow() {
    
    guard
      let model = model,
      let section = model.getCreateAccountSectionIndex() else { return }
    
    self.model?.toggleCreateAccountState()

    if model.createAccountStateIsOpen {
      
      let ip = IndexPath(row: 0, section: section)
      tableView.deleteRows(at: [ip], with: .automatic)
      
    } else {
      
      let ip = IndexPath(row: 0, section: section)
      tableView.insertRows(at: [ip], with: .automatic)
    }
  }
}
