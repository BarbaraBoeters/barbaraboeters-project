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
//        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        geoCheck()
        return true
    }

    // func geofencing  triggered
    func geoCheck() {
        // TODO
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
    
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return true
    }
    
    private func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        print("Tapped in notification")
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == "com.apple.UNNotificationDefaultActionIdentifier" || actionIdentifier == "com.apple.UNNotificationDismissActionIdentifier" {
            return;
        }
        let accept = (actionIdentifier == "com.elonchan.yes")
        let decline = (actionIdentifier == "com.elonchan.no")
        let snooze = (actionIdentifier == "com.elonchan.snooze")
        
        repeat {
            if (accept) {
                let title = "Tom is comming now"
                self.addLabel(title: title, color: UIColor.yellow)
                break;
            }
            if (decline) {
                let title = "Tom won't come";
                self.addLabel(title: title, color: UIColor.red)
                break;
            }
            if (snooze) {
                let title = "Tom will snooze for minute"
                self.addLabel(title: title, color: UIColor.red);
                break;
            }
        } while (false);
        // Must be called when finished
        completionHandler();
    }
    
    private func addLabel(title: String, color: UIColor) {
        let label = UILabel.init()
        label.backgroundColor = UIColor.red
        label.text = title
        label.sizeToFit()
        label.backgroundColor = color
        let centerX = UIScreen.main.bounds.width * 0.5
        let centerY = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height)))
        label.center = CGPoint(x: centerX, y: centerY)
        self.window!.rootViewController!.view.addSubview(label)
    }
    
    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("Notification being triggered")
        // Must be called when finished, when you do not want foreground show, pass [] to the completionHandler()
        completionHandler(UNNotificationPresentationOptions.alert)
        // completionHandler( UNNotificationPresentationOptions.sound)
        // completionHandler( UNNotificationPresentationOptions.badge)
    }

//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//    
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
}

