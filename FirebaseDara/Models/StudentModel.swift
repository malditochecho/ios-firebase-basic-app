//
//  Student.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-29.
//

import Foundation

class StudentModel {
    public var docId : String?
    public var name : String
    public var country : String
    public var expertise : String
    public var absences : Int
    
    /// Constructor for a student without id, to create it later in Firestore.
    init(name: String, country: String, expertise: String, absences: Int) {
        self.name = name
        self.country = country
        self.expertise = expertise
        self.absences = absences
    }
    
    /// Constructor to create an existing firestore student that already has an id.
    /// Used when a student is fetched from firestore and it has to be represented in Swift.
    init(docId: String, name: String, country: String, expertise: String, absences: Int) {
        self.docId = docId
        self.name = name
        self.country = country
        self.expertise = expertise
        self.absences = absences
    }
    
    /// Used in the Firestore's addDocument because it expects a dictionary.
    /// It doesnt have id because it hasnt been created in firestore yet at this point.
    func toDictionary() -> [String: Any] {
        return [
            "docId": docId ?? "",
            "name": name,
            "country": country,
            "expertise": expertise,
            "absences": absences
        ]
    }
}
