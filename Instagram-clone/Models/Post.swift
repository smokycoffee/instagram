//
//  Post.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import Foundation

struct Post: Codable {
    let id: String
    let caption: String
    let postedDate: String
    let postURLString: String
    var likers: [String]
    
    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil}
        
        return "\(username)/posts/\(id).png"
    }
}
