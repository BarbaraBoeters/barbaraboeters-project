//
//  MyGardenViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class MyGardenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var plants: [Plant] = []
    var user: User!
    let ref = FIRDatabase.database().reference(withPath: "plants")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
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
    
    // MARK: Tableview functions
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
}
