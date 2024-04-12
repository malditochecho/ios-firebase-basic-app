//
//  FirestoreProvider.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-04-09.
//

import Foundation
import FirebaseFirestore

class StudentProvider {
    static var students: [StudentModel] = [StudentModel]()
    
    static let db: Firestore = Firestore.firestore()
    static let colRef: CollectionReference = db.collection("students")
    
    static func addDocument(student: StudentModel, completion: @escaping (Bool) -> Void) -> Void {
        colRef.addDocument(data: student.toDictionary()) { (error) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    static func updateDocument(updatedStudent: StudentModel, completion: @escaping (Bool) -> Void) -> Void {
        let docRef = colRef.document(updatedStudent.docId!)
        docRef.updateData(updatedStudent.toDictionary()) { (error) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    static func deleteDocument(studentId: String, completion: @escaping (Bool) -> Void) -> Void {
        let docRef = colRef.document(studentId)
        docRef.delete() { (error) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    static func getDocuments(completion: @escaping (Error?) -> Void) {
        colRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
            } else {
                students.removeAll()
                for document in querySnapshot!.documents {
                    let docId = document.documentID
                    let studentData = document.data()
                    
                    let name = studentData["name"] as! String
                    let country = studentData["country"] as! String
                    let expertise = studentData["expertise"] as! String
                    let absences = studentData["absences"] as! Int
                    
                    let student = StudentModel(docId: docId, name: name, country: country, expertise: expertise, absences: absences)
                    self.students.append(student)
                }
                completion(nil)
            }
        }
    }
}
