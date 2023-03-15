//
//  AuthManager.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager() // singleton
    
    private init() {}
    
    let auth = Auth.auth()
    
    enum AuthError: Error {
        case newUserCreation
    }
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    public func signUp(email: String, username: String, password: String, profilePicture: Data?, completion: @escaping (Result<User, Error>) -> Void) {
        
        let newUser = User(username: username, email: email)
        
        // create account
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(.failure(AuthError.newUserCreation))
                return
            }
            DatabaseManager.shared.createUser(newUser: newUser) { success in
                if success {
                    StorageManager.shared.uploadProfilePicture(username: username, data: profilePicture) { uploadSucess in
                        if uploadSucess {
                            completion(.success(newUser))
                        } else {
                            completion(.failure(AuthError.newUserCreation))
                        }
                    }
                } else {
                    completion(.failure(AuthError.newUserCreation))
                }
            }
            
        }
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
}
