//
//  SignInViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self // hide keyboard
        password.delegate = self // hide keyboard
    }
    
    // MARK: IBActions
    @IBAction func btnLogin(_ sender: Any) {
        if email.text != "" && password.text != "" {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) {
                (authData, error) in
                if error != nil {
                    Toast.ok(view: self, title: "Firebase error", message: error?.localizedDescription ?? "Something went wront!")
                } else {
                    self.password.text = ""
                    self.performSegue(withIdentifier: "fromLoginToHome", sender: nil)
                }
            }
        }
    }
    
    // MARK: Functions
    
    // to hide the keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// procotol used to hide the keyboard after pressing return
extension SignInViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            email.resignFirstResponder()
            password.resignFirstResponder()
            return true
        }
}
