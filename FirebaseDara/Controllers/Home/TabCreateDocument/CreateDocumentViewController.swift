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
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldCountry: UITextField!
    @IBOutlet var textFieldExpertise: UITextField!
    @IBOutlet var textFieldAbsences: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self // hide keyboard
        textFieldCountry.delegate = self // hide keyboard
        textFieldExpertise.delegate = self // hide keyboard
        textFieldAbsences.delegate = self // hide keyboard
    }
    
    // MARK: IBActions
    @IBAction func btnCreateStudent(_ sender: Any) {
        // validate that the text fields are not empty
        guard let name = textFieldName.text, !name.isEmpty,
              let country = textFieldCountry.text, !country.isEmpty,
              let expertise = textFieldExpertise.text, !expertise.isEmpty,
              let absencesText = textFieldAbsences.text,
              let absences = Int(absencesText) else {
            Toast.show(view: self, title: "😬", message: "Fields cannot be empty.", delay: 2)
            return
        }
        
        // create a new student
        let newStudent = StudentModel(name: name, country: country, expertise: expertise, absences: absences)
        
        // add the todo
        StudentProvider.addDocument(student: newStudent) { success in
            if success {
                // clear the inputs
                self.clearTextFields()
                Toast.show(view: self, title: "👍", message: "Student created successfully!", delay: 2)
            } else {
                Toast.show(view: self, title: "😩", message: "There was an error creating the student.", delay: 2)
            }
        }
    }
    
    // MARK: Functions
    func clearTextFields() {
        textFieldName.text = ""
        textFieldCountry.text = ""
        textFieldExpertise.text = ""
        textFieldAbsences.text = ""
    }
    
    // hide the keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// procotol used to hide the keyboard after pressing return
extension CreateDocumentViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textFieldName.resignFirstResponder()
            textFieldCountry.resignFirstResponder()
            textFieldExpertise.resignFirstResponder()
            textFieldAbsences.resignFirstResponder()
            return true
        }
}
