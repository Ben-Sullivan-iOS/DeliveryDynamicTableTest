//
//  ViewController.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

protocol DeliveryTableViewControllerDelegate: class {
  func reloadData()
}

class CheckoutVC: UIViewController, DeliveryTableViewControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var sections: [SectionType] = [.deliverTo, .myDetails, .createAccountHeader, .paymentMethod, .placeOrder]
  var sectionHeaderTitles = [String]()
  
  var createAccountState = CreateAccountState.closed

  enum CreateAccountState {
    case open, closed
  }
  
  enum SectionType {
    
    case deliverTo, collectFrom, myDetails, paymentMethod, createAccount, createAccountHeader, pennies, placeOrder
    
    func getCell(delegate: CheckoutVC, indexPath: IndexPath) -> UITableViewCell {
      switch self {
      case .deliverTo:
        let cell = delegate.tableView.dequeueReusableCell(withIdentifier: "deliverToCell", for: indexPath) as! DeliverToCell
        cell.delegate = delegate
        return cell
        
      case .myDetails:
        return delegate.tableView.dequeueReusableCell(withIdentifier: "myDetailsCell", for: indexPath) as! MyDetailsCell
        
      case .paymentMethod:
        return delegate.tableView.dequeueReusableCell(withIdentifier: "paymentMethodCell", for: indexPath) as! PaymentMethodCell
        
      case .createAccount:
        return delegate.tableView.dequeueReusableCell(withIdentifier: "createAccountCell", for: indexPath) as! CreateAccountCell
       
      case .placeOrder:
        return delegate.tableView.dequeueReusableCell(withIdentifier: "placeOrderCell", for: indexPath)
        
      default:
        return UITableViewCell()
      }
    }
    
    func getHeaderTitle() -> String {
      switch self {
      case .deliverTo:
        return " "
      case .collectFrom:
        return ""
      case .myDetails:
        return "My details"
      case .paymentMethod:
        return "Payment method"
      case .createAccount:
        return ""
      case .pennies:
        return ""
      case .placeOrder:
        return ""
      case .createAccountHeader:
        return "Create an account? (optional)"
      }
    }
    
    func getHeaderView(withViewWidth width: CGFloat, delegate: CheckoutVC) -> UIView {
      switch self {
      case .deliverTo:
        let deliverToNib = UINib(nibName: "DeliverToHeader", bundle: .main)
        let headerView = deliverToNib.instantiate(withOwner: delegate, options: nil).first as! UIView
        return headerView
      case .createAccountHeader:
        let deliverToNib = UINib(nibName: "CreateAccountHeader", bundle: .main)
        let headerView = deliverToNib.instantiate(withOwner: delegate, options: nil).first as! UIView
        let gest = UITapGestureRecognizer(target: delegate, action: #selector(createAccountTapped))
        headerView.addGestureRecognizer(gest)
        return headerView
        
      default: break
        
      }
      
      let rect = CGRect(x: 16, y: 0, width: width, height: 50)
      let headerView = UIView(frame: rect)
      let label = UILabel(frame: rect)
      label.text = self.getHeaderTitle()
      label.textColor = .white
      
      headerView.addSubview(label)
      return headerView
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

    populateSectionHeaderTitles()
    
    tableView.backgroundColor = UIColor(white: 46.0 / 255.0, alpha: 1.0)
    view.backgroundColor = UIColor(white: 46.0 / 255.0, alpha: 1.0)
    
    let deliverToNib = UINib(nibName: "DeliverToCell", bundle: .main)
    tableView.register(deliverToNib, forCellReuseIdentifier: "deliverToCell")
    
    let paymentMethodNib = UINib(nibName: "PaymentMethodCell", bundle: .main)
    tableView.register(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
    
    let myDetailsNib = UINib(nibName: "MyDetailsCell", bundle: .main)
    tableView.register(myDetailsNib, forCellReuseIdentifier: "myDetailsCell")
    
    let placeOrderNib = UINib(nibName: "PlaceOrderCell", bundle: .main)
    tableView.register(placeOrderNib, forCellReuseIdentifier: "placeOrderCell")
    
    let createAccountCell = UINib(nibName: "CreateAccountCell", bundle: .main)
    tableView.register(createAccountCell, forCellReuseIdentifier: "createAccountCell")
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    
  }
  
  func reloadData() {
    tableView.reloadData()
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
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if sections[section] == .createAccountHeader {
      switch createAccountState {
      case .open:
        return 1
      case .closed:
        return 0
      }
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    return sections[indexPath.section].getCell(delegate: self, indexPath: indexPath)
  }
  
}

extension CheckoutVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if sectionHeaderTitles[section] == "" {
      return 0
    }
    return 50
  }
  
  func populateSectionHeaderTitles() {
    sectionHeaderTitles.removeAll()
    for i in sections {
      sectionHeaderTitles.append(i.getHeaderTitle())
    }
  }
  
  @objc func createAccountTapped() {

    let section = sections.index(of: .createAccountHeader)!
    
    if createAccountState == .open {
      createAccountState = .closed

      let ip = IndexPath(row: 0, section: section)
      tableView.deleteRows(at: [ip], with: .automatic)
    } else {
      createAccountState = .open

      let ip = IndexPath(row: 0, section: section)
      tableView.insertRows(at: [ip], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    return sections[section].getHeaderView(withViewWidth: view.frame.width, delegate: self)
  }

}
