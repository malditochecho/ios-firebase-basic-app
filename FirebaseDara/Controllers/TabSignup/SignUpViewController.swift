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
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEmail.delegate = self // hide keyboard
        textFieldPassword.delegate = self // hide keyboard
    }
    
    // MARK: IBActions
    @IBAction func btnRegister(_ sender: Any) {
        
        // validate that the text fields are not empty
        guard let email = textFieldEmail.text, !email.isEmpty,
              let password = textFieldPassword.text, !password.isEmpty else {
            Toast.show(view: self, title: "😬", message: "Fields cannot be empty.", delay: 2)
            return
        }
        
        // validate that the email and password matches
        AuthProvider.signup(email: email, password: password) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.textFieldEmail.text = ""
                    self.textFieldPassword.text = ""
                    self.performSegue(withIdentifier: Segue.fromSignupToHome, sender: self)
                }
            } else {
                self.textFieldPassword.text = ""
                Toast.ok(view: self, title: "🤨", message: "The credentials are not valid.")
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
            textFieldEmail.resignFirstResponder()
            textFieldPassword.resignFirstResponder()
            return true
        }
}
