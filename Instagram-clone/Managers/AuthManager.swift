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
}
