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
    
    let loginToList = "loginToList"
    var ref: FIRDatabaseReference!

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
}
