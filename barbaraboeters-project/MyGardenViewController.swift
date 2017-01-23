//
//  MyGardenViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class MyGardenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    // MARK: Properties
    var plants: [Plant] = []
    var user: User!
    let ref = FIRDatabase.database().reference(withPath: "plants")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    var calendars: [EKCalendar]?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        // checkCalendarAuthorizationStatus()
        // 1
//        self.eventStore = EKEventStore()
//        self.reminders = [EKReminder]()
//        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
//            
//            if granted{
//                // 2
//                let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
//                self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [EKReminder]?) -> Void in
//                    
//                    self.reminders = reminders
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.tableView.reloadData()
//                    }
//                })
//            }else{
//                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "plantj2.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }

        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Plant] = []
            for item in snapshot.children {
                let plantItem = Plant(snapshot: item as! FIRDataSnapshot)
                newItems.append(plantItem)
            }
            self.plants = newItems
            self.tableView.reloadData()
        })
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
    @IBAction func logOutDidTouch(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: Tableviews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlantCell
        let plantItem = plants[indexPath.row]
        cell.plantName?.text = plantItem.name
        cell.plantInfo?.text = plantItem.info
        // cell.plantDaysLeft?.numberOfLines = groceryItem.value
        cell.plantDaysLeft?.text = Int(plantItem.interval).description

        // cell.plantName.text = groceryItem.addedByUser
        // cell.detailTextLabel?.text = groceryItem.addedByUser
        toggleCellCheckbox(cell, isCompleted: plantItem.completed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = plants[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let plantItem = plants[indexPath.row]
        let toggledCompletion = !plantItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        plantItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    /// Checking off items.
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
//    func checkCalendarAuthorizationStatus() {
//        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
//        
//        switch (status) {
//        case EKAuthorizationStatus.notDetermined:
//            // This happens on first-run
//            requestAccessToCalendar()
//        case EKAuthorizationStatus.authorized:
//            // Things are in line with being able to show the calendars in the table view
//            loadCalendars()
//            //refreshTableView()
//        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
//            // We need to help them give us permission
//            needPermissionView()
//        }
//    }
//    func requestAccessToCalendar() {
//        eventStore.requestAccess(to: EKEntityType.event, completion: {
//            (accessGranted: Bool, error: Error?) in
//            
//            if accessGranted == true {
//                DispatchQueue.main.async(execute: {
//                    self.loadCalendars()
//                    //self.refreshTableView()
//                })
//            } else {
//                DispatchQueue.main.async(execute: {
//                    self.needPermissionView()
//                })
//            }
//        })
//    }
//    func loadCalendars() {
//        self.calendars = eventStore.calendars(for: EKEntityType.event)
//    }
//    func needPermissionView() {
//        let alert = UIAlertController(title: "Access",
//                                      message: "We need access to your calender",
//                                      preferredStyle: .alert)
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
//            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
//                return
//            }
//            
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
//                })
//            }
//        }
//        alert.addAction(settingsAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    func refreshTableView() {
//        calendarsTableView.isHidden = false
//        calendarsTableView.reloadData()
//    }
}
