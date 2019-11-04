//
//  AppDelegate.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = NavigationController()
        window?.rootViewController = navigationController
        
        let flowController = FlowController(navigationController: navigationController)
      
        flowController.start()
        return true
    }

   

}

