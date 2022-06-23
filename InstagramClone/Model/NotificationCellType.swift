//
//  NotificationCellType.swift
//  InstagramClone
//
//  Created by Admin on 4/19/22.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel : FollowNotificationCellViewModel)
    case like(viewModel : LikeNotificationCellViewModel)
    case comment(viewModel : CommentNotificationCellViewModel)
}
