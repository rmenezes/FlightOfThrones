//
//  AppDelegate.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let injectionContainer = FlightOfThronesAppDependencyContainer()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow()
        // Only for testing
        window?.rootViewController = UINavigationController(rootViewController: injectionContainer.makeHomeViewController())
        window?.makeKeyAndVisible()
        
        // General Apperance
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        return true
    }
}

