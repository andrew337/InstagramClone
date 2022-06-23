//
//  Notification.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import Foundation


struct IGNotification : Codable {
    let identifier : String
    let notificationType : Int
    let profilePictureURL : String
    let username  : String
    let dateString : String
    //Follow/Unfollow
    let isFollowing : Bool?
    //Like/Comment
    let postID : String?
    let postURL : String?
}
