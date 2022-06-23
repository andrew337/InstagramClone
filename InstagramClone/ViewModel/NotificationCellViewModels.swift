//
//  NotificationCellViewModels.swift
//  InstagramClone
//
//  Created by Admin on 4/19/22.
//

import Foundation

struct LikeNotificationCellViewModel : Equatable {
    let username : String
    let profilePictureURL : URL
    let postURL : URL
    let date : String
}
struct FollowNotificationCellViewModel : Equatable {
    let username : String
    let profilePictureUrl : URL
    let isCurrentUserFollowing : Bool
    let date : String
}
struct CommentNotificationCellViewModel : Equatable {
    let username : String
    let profilePictureURL : URL
    let postURL : URL
    let date : String
}
