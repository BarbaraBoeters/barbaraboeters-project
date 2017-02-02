//
//  AppDelegate.swift
//  barbaraboeters-project
//
//  Establishes the connection to the different frameworks (Firebase, IQKeyboardManagerSwift, CoreLocation)
//
//  Created by Barbara Boeters on 09-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        locationManager.requestAlwaysAuthorization()
        return true
    }
}
