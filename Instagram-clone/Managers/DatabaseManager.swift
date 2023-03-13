//
//  DatabaseManager.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    static let shared = DatabaseManager() // singleton
    
    private init() {}
    
    let database = Firestore.firestore()
}

