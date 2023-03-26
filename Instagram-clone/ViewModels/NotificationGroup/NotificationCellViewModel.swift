//
//  NotificationCellViewModel.swift
//  Instagram-clone
//
//  Created by Tsenguun on 26/3/23.
//

import Foundation

struct LikeNotificationCellViewModel {
    let username: String
    let profilePictureURL: URL
    let postURL: URL
}

struct FollowNotificationCellViewModel {
    let username: String
    let profilePictureURL: URL
    let isCurrentUserFollowing: Bool
}

struct CommentNotificationCellViewModel {
    let username: String
    let profilePictureURL: URL
    let postURL: URL
}
