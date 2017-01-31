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
    }
    
    // MARK: Actions to Login or Signup in Firebase
    @IBAction func signUpDidTouch(_ sender: Any) {
        if textFieldEmail.text != "" && textFieldPassword.text != "" {
            FIRAuth.auth()!.createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { user, error in
                if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: self.textFieldEmail.text!, password: self.textFieldPassword.text!)
                } else {
                    self.errorAlert(title: "Error", text: "You entered an e-mail that already exists")
                }
            }
        } else {
            errorAlert(title: "Error", text: "Please enter a valid e-mail and/or password")
        }
    }

    @IBAction func logInDidTouch(_ sender: Any) {
        if textFieldEmail.text != "" && textFieldPassword.text != "" {
            FIRAuth.auth()!.signIn(withEmail: textFieldEmail.text!, password: textFieldPassword.text!)
        } else {
            errorAlert(title: "Error", text: "You didn't enter a valid e-mail and/or password")
        }
    }
    
    func errorAlert(title: String, text: String) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
