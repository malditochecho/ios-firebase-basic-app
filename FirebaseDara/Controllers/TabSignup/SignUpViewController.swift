//
//  SignUpViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
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
    @IBAction func btnRegister(_ sender: Any) {
        if let email = email.text, !email.isEmpty,
           let password = password.text, !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) {
                (authData, error) in
                if error != nil {
                    Toast.ok(view: self, title: "Firebase error", message: error?.localizedDescription ?? "Something went wrong!")
                    self.password.text = ""
                } else {
                    self.performSegue(withIdentifier: "fromSignupToHome", sender: nil)
                    self.email.text = ""
                    self.password.text = ""
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
extension SignUpViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            email.resignFirstResponder()
            password.resignFirstResponder()
            return true
        }
}
