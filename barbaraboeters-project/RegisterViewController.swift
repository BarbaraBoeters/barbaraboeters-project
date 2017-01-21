//
//  RegisterViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 11-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    // MARK: Properties
    let loginToList = "loginToList"
    var ref: FIRDatabaseReference!
    var user: User!

    // MARK: Outlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create an authentication observer using addStateDidChangeListener(_:).
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }

        ref = FIRDatabase.database().reference()
        // let user = FIRAuth.auth()?.currentUser
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
//        let email = user?.email
//        let uid = user?.uid
        // let photoURL = user?.photoURL
        // print(email)
        // print(uid)
    }
    
    // MARK: Actions
    @IBAction func signUpDidTouch(_ sender: Any) {
        if textFieldEmail.text != "" && textFieldPassword.text != "" {
            FIRAuth.auth()!.createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { user, error in
                if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: self.textFieldEmail.text!, password: self.textFieldPassword.text!)
//                    let userID: String = user!.uid
//                    let userEmail: String = self.textFieldEmail.text!
//                    self.ref.child("Users").child(userID).setValue(["email": userEmail])
                }
            }
        } else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "You didn't enter a valid e-mail and/or password",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func logInDidTouch(_ sender: Any) {
        if textFieldEmail.text != "" && textFieldPassword.text != "" {
            FIRAuth.auth()!.signIn(withEmail: textFieldEmail.text!, password: textFieldPassword.text!)
        } else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "You didn't enter a valid e-mail and/or password",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        animateViewMoving(up: true, moveValue: 100)
//    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        animateViewMoving(up: false, moveValue: 100)
//    }
//    
//    func animateViewMoving (up:Bool, moveValue :CGFloat){
//        let movementDuration:TimeInterval = 0.3
//        let movement:CGFloat = ( up ? -moveValue : moveValue)
//        UIView.beginAnimations( "animateView", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(movementDuration )
//        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
//        UIView.commitAnimations()
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textFieldEmail.endEditing(true)
//        textFieldPassword.endEditing(true)
//    }
        
}
