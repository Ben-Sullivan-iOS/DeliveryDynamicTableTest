//
//  ViewController.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

protocol DeliveryTableViewControllerDelegate: class {
  var _tableView: UITableView? { get }
  func reloadData()
}

class CheckoutVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var sections: [SectionType] = [.deliverTo, .myDetails, .createAccountHeader, .paymentMethod, .placeOrder]
  var sectionHeaderTitles = [HeaderTitle]()
  
  var createAccountState = CreateAccountState.closed

  enum CreateAccountState: Int {
    case closed, open
    
    func numberOfRows() -> Int {
      switch self {
      case .open:
        return 1
      case .closed:
        return 0
      }
    }
  }
  
  enum HeaderTitle {
    case fromString(String)
    case fromXib
    case none
    
    func headerHeight() -> CGFloat {
      switch self {
      case .fromXib, .fromString(_):
        return 50
      case .none:
        return 0
      }
    }
  }
  
  enum SectionType {
    
    case deliverTo, collectFrom, myDetails, paymentMethod, createAccount, createAccountHeader, pennies, placeOrder
    
    func cell(delegate: DeliveryTableViewControllerDelegate, indexPath: IndexPath) -> UITableViewCell {
      
      guard let tableView = delegate._tableView else { return UITableViewCell() }
      
      switch self {
      case .deliverTo:
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliverToCell", for: indexPath) as! DeliverToCell
        cell.delegate = delegate
        return cell
        
      case .myDetails:
        return tableView.dequeueReusableCell(withIdentifier: "myDetailsCell", for: indexPath) as! MyDetailsCell
        
      case .paymentMethod:
        return tableView.dequeueReusableCell(withIdentifier: "paymentMethodCell", for: indexPath) as! PaymentMethodCell
        
      case .createAccountHeader:
        return tableView.dequeueReusableCell(withIdentifier: "createAccountCell", for: indexPath) as! CreateAccountCell
       
      case .placeOrder:
        return tableView.dequeueReusableCell(withIdentifier: "placeOrderCell", for: indexPath)
        
      default:
        return UITableViewCell()
      }
    }
    
    func headerTitle() -> HeaderTitle {
      switch self {
      case .deliverTo, .createAccountHeader:
        return .fromXib
        
      case .myDetails:
        return .fromString("My details")
        
      case .paymentMethod:
        return .fromString("Payment method")
        
      case .createAccount, .pennies, .placeOrder, .collectFrom:
        return .none
      }
    }
    
    func numberOfRows(createAccountState: CreateAccountState) -> Int {
      switch self {
      case .createAccountHeader:
        return createAccountState.numberOfRows()
      default: return 1
      }
    }
    
    func headerView(withViewWidth width: CGFloat, delegate: CheckoutVC) -> UIView {
      switch self {
      case .deliverTo:
        let deliverToNib = UINib(nibName: "DeliverToHeader", bundle: .main)
        let headerView = deliverToNib.instantiate(withOwner: delegate, options: nil).first as! UIView
        headerView.backgroundColor = UIColor(named: "DomBackground")
        return headerView
      case .createAccountHeader:
        let deliverToNib = UINib(nibName: "CreateAccountHeader", bundle: .main)
        let headerView = deliverToNib.instantiate(withOwner: delegate, options: nil).first as! UIView
        let gest = UITapGestureRecognizer(target: delegate, action: #selector(insertCreateAccountRow))
        headerView.addGestureRecognizer(gest)
        headerView.backgroundColor = UIColor(named: "DomBackground")

        return headerView
        
      default: break
        
      }
      
      let rect = CGRect(x: 16, y: 0, width: width, height: 50)
      let headerView = UIView(frame: rect)
      headerView.backgroundColor = UIColor(named: "DomBackground")
      let label = UILabel(frame: rect)
      
      switch self.headerTitle() {
      case .fromString(let str):
        label.text = str
      default: break
      }
      
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
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //  Prevents sticky headers, there must be a native way?!
    let dummyViewHeight = CGFloat(40)
    self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  private func populateSectionHeaderTitles() {
    sectionHeaderTitles.removeAll()
    for i in sections {
      sectionHeaderTitles.append(i.headerTitle())
    }
  }
  
}

extension CheckoutVC: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].numberOfRows(createAccountState: createAccountState)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return sections[indexPath.section].cell(delegate: self, indexPath: indexPath)
  }
  
}

extension CheckoutVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return sectionHeaderTitles[section].headerHeight()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return sections[section].headerView(withViewWidth: view.frame.width, delegate: self)
  }

}

extension CheckoutVC: DeliveryTableViewControllerDelegate {
  
  var _tableView: UITableView? {
    return tableView
  }
  
  @objc func insertCreateAccountRow() {
    
    guard let section = sections.index(of: .createAccountHeader) else { return }
    
    if createAccountState == .open {
      createAccountState = .closed
      
      let ip = IndexPath(row: 0, section: section)
      tableView.deleteRows(at: [ip], with: .automatic)
    } else if createAccountState == .closed {
      createAccountState = .open
      
      let ip = IndexPath(row: 0, section: section)
      tableView.insertRows(at: [ip], with: .automatic)
    }
  }
}
