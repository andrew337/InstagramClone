//
//  Post.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import Foundation


struct Post : Codable {
    let id : String
    let caption : String
    let postedDate : String
    let postURLString : String
    var likers : [String]
    
    var storageReference : String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/posts/\(id).png"
    }
}
