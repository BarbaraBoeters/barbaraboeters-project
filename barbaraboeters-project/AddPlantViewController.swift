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

    let ref = FIRDatabase.database().reference(withPath: "plants")
    var user: User!
    var items: [Plant] = []
    var optionalString: String?
    var turnedString: Int?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldInfo: UITextField!
    @IBOutlet weak var labelStepper: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
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
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        labelStepper.text = Int(sender.value).description
        // let value = Int(sender.value).description
        // print(labelStepper.text)
        optionalString = labelStepper.text
        
        // Make sure that the string is not nil
        if let unwrappedString = optionalString {
            
            // convert String to Int
            let optionalInt = Int(unwrappedString)
            turnedString = optionalInt
            // Make sure the string was actually an integer
            if let upwrappedInt = optionalInt {
                print(upwrappedInt)
            }
        }
    }
    
    @IBAction func addPlant(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
        // let email = user?.email
        let userUid = user?.uid
        // let photoURL = user?.photoURL
        // let value = Int(UIStepper.value(UIStepper)

        //if textFieldName.text != nil {
        let text = textFieldName.text!
        let plant = Plant(name: text,
                          uid: userUid!,
                          completed: false,
                          info: textFieldInfo.text!,
                          value: turnedString!)
        let plantItemRef = self.ref.child(text.lowercased())
        plantItemRef.setValue(plant.toAnyObject())
    }
}
