//
//  NotificationCellType.swift
//  Instagram-clone
//
//  Created by Tsenguun on 26/3/23.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
