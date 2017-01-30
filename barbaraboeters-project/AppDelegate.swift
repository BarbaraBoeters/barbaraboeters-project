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
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var plants: [Plant] = []
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        //locationManager.requestAlwaysAuthorization()
        geoCheck()
        return true
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
//        IQKeyboardManager.sharedManager().enable = true
//        FIRApp.configure()
//        FIRDatabase.database().persistenceEnabled = true
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
////        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
////        UIApplication.shared.cancelAllLocalNotifications()
//        return true
//    }
    
//    func handleEvent(forRegion region: CLRegion!) {
//        // Show an alert if application is active
//        print("Geofence triggered!")
//        if UIApplication.shared.applicationState == .active {
//            guard let message = note(fromRegionIdentifier: region.identifier) else { return }
//            window?.rootViewController?.showAlert(withTitle: nil, message: message)
//        } else {
//            // Otherwise present a local notification
//            let notification = UILocalNotification()
//            notification.alertBody = note(fromRegionIdentifier: region.identifier)
//            notification.soundName = "Default"
//            UIApplication.shared.presentLocalNotificationNow(notification)
//        }
//    }
    
    // TODO func or listener geofencing triggered
    func geoCheck() {
        // updatePlants()
    }
    
    
    func updatePlants() {
        let ref = FIRDatabase.database().reference(withPath: "plants")

        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let plantItem = Plant(snapshot: item as! FIRDataSnapshot)
                self.plants.append(plantItem)
            }
            self.checkIntervalPlants()
        })
    }
    
    private func checkIntervalPlants() {
        for plant in plants {
            let lastUpdated = Date(timeIntervalSince1970: plant.lastUpdated)
            let timeDifference = Date().timeIntervalSince(lastUpdated)
            let interval = Double(plant.interval * 24 * 60 * 60)
            if timeDifference - interval >= 0 {
                notifications()
            }
        }
    }
    
    // TODO
    func notifications() {
        let alert = UIAlertController(title: "Yay!",
                                      message: "Please water",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
    }

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

//extension AppDelegate: CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            handleEvent(forRegion: region)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            handleEvent(forRegion: region)
//        }
//    }
//}

