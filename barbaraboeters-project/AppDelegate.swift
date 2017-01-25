//
//  AppDelegate.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 09-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var eventStore: EKEventStore?
    var plants: [Plant] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        //updatePlants()
        geoCheck()
        return true
    }

    // func geofencing  triggered
    func geoCheck() {
        // TODO
        updatePlants()
    }
    
    
    func updatePlants() {
        let ref = FIRDatabase.database().reference(withPath: "plants")

        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let plantItem = Plant(snapshot: item as! FIRDataSnapshot)
                self.plants.append(plantItem)
            }
            print("DEZE \(self.plants)")
            self.checkIntervalPlants()
        })
    }
    
    private func checkIntervalPlants() {
        for plant in plants {
            print(plant.lastUpdated)
            let lastUpdated = Date(timeIntervalSince1970: plant.lastUpdated)
            let timeDifference = Date().timeIntervalSince(lastUpdated)
            let interval = Double(plant.interval * 24 * 60 * 60)
            if timeDifference - interval >= 0 {
                // TODO func notificaties
            }
        }
    }
    
    // todo func notificaties
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

