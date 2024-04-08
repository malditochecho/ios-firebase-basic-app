//
//  AuthProvider.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-04-08.
//

import Foundation
import Firebase

class AuthProvider {
    static var auth: Auth = Auth.auth()
    
    /// Authenticate a user in Firebase Auth
    static func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) {
            (authData, error) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    /// Create a new user and set it as the authenticated user in Firebase Auth
    static func signup(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) {
            (authData, error) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    /// Logout the current authenticated user in Firebase Auth
    static func logout(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("Error: \(signOutError)")
            completion(false)
        }
    }
}
