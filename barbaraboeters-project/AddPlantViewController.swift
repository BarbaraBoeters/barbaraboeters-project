//
//  AddPlantViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AddPlantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // Mark: Properties
    let imagePicker = UIImagePickerController()
    let ref = FIRDatabase.database().reference(withPath: "plants")
    var user: User!
    var items: [Plant] = []
    var optionalString: String?
    var turnedString: Int?
    var latitude: Double?
    var longitude: Double?
    let locationManager = CLLocationManager()
    
    // Mark: Outlets
    @IBOutlet weak var image: RoundedImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldInfo: UITextField!
    @IBOutlet weak var labelStepper: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.image.reloadInputViews()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        print("SAVED LOCATION = \(latitude),\(longitude)")
    }
    
    // MARK: Actions
    @IBAction func addPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        labelStepper.text = Int(sender.value).description
        optionalString = labelStepper.text
        if let unwrappedString = optionalString {
            let optionalInt = Int(unwrappedString)
            turnedString = optionalInt!
            if let upwrappedInt = optionalInt {
                print(upwrappedInt)
            }
        }
    }
    
    @IBAction func addPlant(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        let userUid = user?.uid
        if textFieldName.text != "" && latitude != nil {
            let text = textFieldName.text!
            let plant = Plant(name: text,
                              uid: userUid!,
                              completed: false,
                              info: textFieldInfo.text!,
                              interval: turnedString!,
                              lastUpdated: 0, // Date().timeIntervalSince1970,
                              latitude: latitude!,
                              longitude: longitude!)
            let plantRef = self.ref.childByAutoId()
            plantRef.setValue(plant.toAnyObject())
        } else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "You didn't enter the right information ay",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
