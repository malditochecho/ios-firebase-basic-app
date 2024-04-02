//
//  CreateDocumentViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import Firebase

class CreateDocumentViewController: UIViewController {
    
    // MARK: Variables
    @IBOutlet var name: UITextField!
    @IBOutlet var country: UITextField!
    @IBOutlet var expertise: UITextField!
    @IBOutlet var absences: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self // hide keyboard
        country.delegate = self // hide keyboard
        expertise.delegate = self // hide keyboard
        absences.delegate = self // hide keyboard
    }
    
    // MARK: IBActions
    @IBAction func btnCreateStudent(_ sender: Any) {
        if let name = name.text, !name.isEmpty,
           let country = country.text, !country.isEmpty,
           let expertise = expertise.text, !expertise.isEmpty,
           let absences = absences.text, !absences.isEmpty {
            Task {
                do {
                    let db = Firestore.firestore()
                    try await db.collection("students").addDocument(data:[
                        "name": name,
                        "country": country,
                        "expertise": expertise,
                        "absences": absences
                    ])
                    clearTextFields()
                    Toast.show(view: self, title: "Success", message: "Document created successfully.", delay: 2)
                } catch {
                    Toast.ok(view: self, title: "Firebase Error", message: error.localizedDescription)
                }
            }
        } else {
            Toast.ok(view: self, title: "Warning", message: "Please fill in all fields.")
        }
    }
    
    // MARK: Functions
    func clearTextFields() {
        name.text = ""
        country.text = ""
        expertise.text = ""
        absences.text = ""
    }
    
    // hide the keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// procotol used to hide the keyboard after pressing return
extension CreateDocumentViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            name.resignFirstResponder()
            country.resignFirstResponder()
            expertise.resignFirstResponder()
            absences.resignFirstResponder()
            return true
        }
}
