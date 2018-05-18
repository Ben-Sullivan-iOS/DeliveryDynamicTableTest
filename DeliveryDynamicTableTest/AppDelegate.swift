//
//  AppDelegate.swift
//  DeliveryDynamicTableTest
//
//  Created by Ben Sullivan on 16/05/2018.
//  Copyright © 2018 Sullivan Applications. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let firstVC = CheckoutVC(nibName: "DeliveryTableView", bundle: .main)
    
    window?.rootViewController = firstVC
    window?.makeKeyAndVisible()
    
    return true
  }
}

