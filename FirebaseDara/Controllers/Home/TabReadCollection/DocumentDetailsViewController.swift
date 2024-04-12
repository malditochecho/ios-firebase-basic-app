//
//  DocumentDetailsViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import FirebaseFirestore

protocol DocumentDetailsViewControllerDelegate {
    func refreshTable()
}

class DocumentDetailsViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldCountry: UITextField!
    @IBOutlet var textFieldExpertise: UITextField!
    @IBOutlet var textFieldAbsence: UITextField!
    
    // MARK: Variables
    var student: StudentModel!
    var delegate : DocumentDetailsViewControllerDelegate?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldName.delegate = self // hide keyboard
        self.textFieldCountry.delegate = self // hide keyboard
        self.textFieldExpertise.delegate = self // hide keyboard
        self.textFieldAbsence.delegate = self // hide keyboard
        
        textFieldName.text = student.name
        textFieldCountry.text = student.country
        textFieldExpertise.text = student.expertise
        textFieldAbsence.text = String(student.absences)
    }
    
    // MARK: IBActions
    @IBAction func btnUpdate(_ sender: Any) {
        // validate that the text fields are not empty
        guard let name = textFieldName.text, !name.isEmpty,
              let country = textFieldCountry.text, !country.isEmpty,
              let expertise = textFieldExpertise.text, !expertise.isEmpty,
              let absencesText = textFieldAbsence.text,
              let absences = Int(absencesText) else {
            Toast.show(view: self, title: "😬", message: "Fields cannot be empty.", delay: 2)
            return
        }
        
        let updatedStudent = StudentModel(docId: student.docId!,
                                          name: name,
                                          country: country,
                                          expertise: expertise,
                                          absences: absences)
        
        StudentProvider.updateDocument(updatedStudent: updatedStudent) { success in
            if success {
                // clear the inputs
                self.clearTextFields()
                Toast.show(view: self, title: "👍", message: "Student updated successfully!", delay: 2)
            } else {
                Toast.show(view: self, title: "😩", message: "There was an error updating the student.", delay: 2)
            }
            self.delegate?.refreshTable()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func btnDelete(_ sender: Any) {
        StudentProvider.deleteDocument(studentId: student.docId!) { success in
            if success {
                // clear the inputs
                self.clearTextFields()
                Toast.show(view: self, title: "👍", message: "Student deleted successfully!", delay: 2)
            } else {
                Toast.show(view: self, title: "😩", message: "There was an error deleting the student.", delay: 2)
            }
            self.delegate?.refreshTable()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Functions
    // hide the keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Functions
    func clearTextFields() {
        textFieldName.text = ""
        textFieldCountry.text = ""
        textFieldExpertise.text = ""
        textFieldAbsence.text = ""
    }
}

// procotol used to hide the keyboard after pressing return
extension DocumentDetailsViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textFieldName.resignFirstResponder()
            textFieldCountry.resignFirstResponder()
            textFieldExpertise.resignFirstResponder()
            textFieldAbsence.resignFirstResponder()
            return true
        }
}
