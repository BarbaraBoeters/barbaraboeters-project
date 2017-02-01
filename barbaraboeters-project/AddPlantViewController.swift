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
import Photos
import FirebaseStorage

class AddPlantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // Mark: Properties
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()

    let ref = FIRDatabase.database().reference(withPath: "plants")
    let storageRef = FIRStorage.storage().reference()
    var pickedImageData: Data?

    var user: User!
    var items: [Plant] = []
    
    var optionalString: String?
    var turnedString: Int?

    var latitude: Double?
    var longitude: Double?
    
    // Mark: Outlets
    @IBOutlet weak var image: RoundedImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldInfo: UITextField!
    @IBOutlet weak var labelStepper: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Actions
    @IBAction func addPhoto(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        labelStepper.text = Int(sender.value).description
        optionalString = labelStepper.text
        if let unwrappedString = optionalString {
            let optionalInt = Int(unwrappedString)
            turnedString = optionalInt!
        }
    }
    
    @IBAction func addPlant(_ sender: Any) {
        if let data = pickedImageData {
            let user = FIRAuth.auth()?.currentUser
            let userUid = user?.uid
            let plantRef = self.ref.childByAutoId()
            storageRef.child("plants").child("/image_\(plantRef.key).jpg").put(data, metadata: nil, completion: { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let urlString = metaData?.downloadURL()?.absoluteString
                
                if self.latitude != nil && self.longitude != nil {
                    if self.textFieldName.text != "" {
                        if self.turnedString != nil {
                            let text = self.textFieldName.text!
                            let plant = Plant(name: text,
                                              uid: userUid!,
                                              completed: false,
                                              info: self.textFieldInfo.text!,
                                              interval: self.turnedString!,
                                              lastUpdated: Date().timeIntervalSince1970, // 0,
                                              latitude: self.latitude!,
                                              longitude: self.longitude!,
                                              imageUrl: urlString!)
                            plantRef.setValue(plant.toAnyObject(), withCompletionBlock: { (error, reference) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                                print(plant)
                            })
                        } else {
                            self.alertError(title: "Error", text: "Please select after how many days you want to be reminded")
                        }
                    } else {
                        self.alertError(title: "Error", text: "You need to at least fill in the name of the plant")
                    }
                } else {
                    self.alertError(title: "Error", text: "Please set your location first")
                }
            })
        } else {
            self.alertError(title: "Error", text: "Please select a photo")
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func alertError(title: String, text: String) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddPlantViewController {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginaleImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            self.image.image = selectedImage
        }
        let compressData = UIImageJPEGRepresentation(selectedImageFromPicker!, 0.4)!
        pickedImageData = compressData
        imagePicker.dismiss(animated: true, completion:nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion:nil)
    }
}

