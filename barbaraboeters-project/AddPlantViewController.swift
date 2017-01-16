//
//  AddPlantViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class AddPlantViewController: UIViewController {

    // let usersRef = FIRDatabase.database().reference(withPath: "users")

    var user: User!
    var items: [Plant] = []

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldInfo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addPhoto(_ sender: Any) {


    }
    
    @IBAction func addPlant(_ sender: Any) {
        if textFieldName.text != nil {
            let plant = Plant(name: textFieldName.text!,
                              addedByUser: self.user.email,
                              completed: false,
                              info: textFieldInfo.text!)
            self.items.append(plant)
//            let name = textFieldName.text
//            let info = textFieldInfo.text
//            let addedByUser = 
//            
//            let plant : [String : AnyObject] = ["name" : name as AnyObject,
//                                                "info" : info as AnyObject]
//            
//            let databaseRef = FIRDatabase.database().reference()
//            databaseRef.child("Plants").childByAutoId().setValue(plant)
//            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
