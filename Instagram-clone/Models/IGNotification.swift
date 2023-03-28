//
//  Notification.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import Foundation

struct IGNotification: Codable {
    let identifier: String
    let notificationType: Int // 1, 2 or 3, like comment or follow
    let profilePictureURL: String
    let username: String
    let dateString: String
    // optional
    let isFollowing: Bool? // follow / unfollow
    
    // like/comment
    let postId: String?
    let postURL: String?
}
