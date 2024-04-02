//
//  DocumentDetailsViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import FirebaseFirestore

class DocumentDetailsViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldCountry: UITextField!
    @IBOutlet var textFieldExpertise: UITextField!
    @IBOutlet var textFieldAbsence: UITextField!
    
    // MARK: Variables
    var student: Student!
    
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
        textFieldAbsence.text = String(student.absences!)
    }
    
    // MARK: IBActions
    @IBAction func btnUpdate(_ sender: Any) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("students").document(student.docId!)
        
        docRef.updateData([
            "docId": student.docId!,
            "name": textFieldName.text!,
            "country": textFieldCountry.text!,
            "expertise": textFieldExpertise.text!,
            "absences": Int(textFieldAbsence.text ?? "0")!
        ]) { (error) in
            if error != nil {
                Toast.ok(view: self, title: "Firebase Error", message: error!.localizedDescription)
            } else {
                Toast.show(view: self, title: "Success", message: "Document updated successfully.", delay: 2)
            }
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("students").document(student.docId!)
        docRef.delete() { (error) in
            if error != nil {
                Toast.ok(view: self, title: "Firebase Error", message: error!.localizedDescription)
            } else {
                Toast.show(view: self, title: "Deleted", message: "Document deleted successfully.", delay: 1)
            }
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Functions
    // hide the keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
