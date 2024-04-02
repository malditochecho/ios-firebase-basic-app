//
//  ReadDocumentViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UploadImageViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitle: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageTitle.delegate = self // hide keyboard
        
        // make image clickable
        imageView.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecogniser)
    }
    
    // MARK: IBActions
    @IBAction func btnUploadPressed(_ sender: Any) {
        let storage = Storage.storage()
        let reference = storage.reference()
        
        let mediaFolder = reference.child("media")
        
        // convert image to buffer type
        if let buffer = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(buffer, metadata: nil) {
                (metadata, error) in
                if error != nil {
                    Toast.ok(view: self, title: "Erorr", message: error?.localizedDescription ?? "Something went wrong")
                } else {
                    imageReference.downloadURL() {
                        (url, error) in
                        if error != nil {
                            Toast.ok(view: self, title: "Error", message: error?.localizedDescription ?? "Firebase: Something went wrong.")
                        } else {
                            let imageUrl = url?.absoluteString

                            let imageData = [
                                "imageUrl": imageUrl!,
                                "uploadedBy": Auth.auth().currentUser!.email!,
                                "title": self.imageTitle.text!,
                                "date": FieldValue.serverTimestamp()
                            ] as [String : Any]
                            
                            let db = Firestore.firestore()
                            db.collection("images").addDocument(data: imageData, completion: {
                                (error) in
                                if error != nil {
                                    Toast.ok(view: self, title: "Error", message: error?.localizedDescription ?? "Unable to store image.")
                                } else{
                                    self.imageView.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
                                    self.imageTitle.text = ""
                                    Toast.show(view: self, title: "Success", message: "Image uploaded successfully", delay: 2)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // hide the keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// procotol used to hide the keyboard after pressing return
extension UploadImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        imageTitle.resignFirstResponder()
        return true
    }
}
