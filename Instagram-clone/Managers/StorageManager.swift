//
//  StorageManager.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager() // singleton
    
    private init() {}
    
    let storage = Storage.storage()
}
