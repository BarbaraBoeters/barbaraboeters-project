//
//  MyGardenViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase
import Photos
import FirebaseStorage

class MyGardenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var plants: [Plant] = []
    var user: User!
    
    var storage: FIRStorage!
    var storageRef: FIRStorageReference!
    let ref = FIRDatabase.database().reference(withPath: "plants")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let currentUser = FIRDatabase.database().reference(withPath: "users").child((FIRAuth.auth()?.currentUser)!.uid)
    var currentU = ""
    
    
    var picArray = [UIImage]()
    
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
        retrieveDataFirebase()
        configureStorage()
    }
    
    func configureStorage() {
        let storageUrl = FIRApp.defaultApp()?.options.storageBucket
        storageRef = FIRStorage.storage().reference(forURL: "gs://barbaraboeters-project.appspot.com")
    }
    
    // MARK: Firebase Data Retrieval Function
    func retrieveDataFirebase() {
        ref.queryOrdered(byChild: "interval").observe(.value, with: { snapshot in
            var newItems: [Plant] = []
            for item in snapshot.children {
                let plantItem = Plant(snapshot: item as! FIRDataSnapshot)
                self.currentU = (FIRAuth.auth()!.currentUser?.uid)!
                let plantUid = plantItem.uid
                if plantUid == self.currentU {
                    newItems.append(plantItem)
                }
            }
            self.plants = newItems
            self.tableView.reloadData()
        })
    }

    


    
    // MARK: Actions
    @IBAction func logOutDidTouch(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Tableview Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlantCell
        let plantItem = plants[indexPath.row]
        cell.plantName?.text = plantItem.name
        cell.plantInfo?.text = plantItem.info
        cell.plantDaysLeft?.text = Int(plantItem.interval).description
        //cell.plantImage.image = UIImage(named: "")
        
        let profileImageUrl = plantItem.imageUrl
        let url = NSURL(string: profileImageUrl)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                cell.plantImage?.image = UIImage(data: data!)

            })
        }).resume()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plantItem = plants[indexPath.row]
            plantItem.ref?.removeValue()
        }
    }

}



