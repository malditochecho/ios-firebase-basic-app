//
//  Student.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-29.
//

import Foundation

class Student {
    public var docId : String?
    public var name : String?
    public var country : String?
    public var expertise : String?
    public var absences : Int?
    
    init() {
        self.docId = ""
        self.name = ""
        self.country = ""
        self.expertise = ""
        self.absences = 0
    }
}
