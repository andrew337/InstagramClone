//
//  DatabaseManager.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    public func findUsers(with usernamePrefix: String, completion: @escaping ([User]) -> Void) {
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            
            let subset = users.filter({
                $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
            })
            completion(subset)
        }
    }
    
    public func posts(for username : String, completion : @escaping (Result<[Post], Error>) -> Void) {
        let ref = database.collection("users").document(username).collection("posts")
        ref.getDocuments { snapshot, error in
            guard let posts = snapshot?.documents.compactMap( {
                Post(with: $0.data())
            }), error == nil else {
                return
            }
            
            completion(.success(posts))
        }
    }
    
    public func findUser(with email: String, completion : @escaping (User?) -> Void) {
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            
            let user = users.first(where: { $0.email == email })
            completion(user)
        }
    }
    
    public func findUser(username: String, completion : @escaping (User?) -> Void) {
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            
            let user = users.first(where: { $0.username == username })
            completion(user)
        }
    }
    
    public func createPost(newPost : Post, completion : @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        let reference = database.document("users/\(username)/posts/\(newPost)")
        
        guard let data = newPost.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data) { error in
            completion(error == nil)
        }
    }
    
    public func createUser(newUser : User, completion : @escaping (Bool) -> Void) {
        let reference = database.document("users/\(newUser.username)")
        
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data) { error in
            completion(error == nil)
        }
    }
    
    public func explorePosts(completion: @escaping ([Post]) -> Void) {
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            var aggregatePosts = [Post]()
            
            users.forEach { user in
                group.enter()
                let username = user.username
                let postRef = self.database.collection("users/\(username)/posts")
                
                postRef.getDocuments { snapshot, error in
                    defer {
                        group.leave()
                    }
                    guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data()) }), error == nil else {
                        completion([])
                        return
                    }
                    
                    aggregatePosts.append(contentsOf: posts)
                    
                }
            }
            
            group.notify(queue: .main) {
                completion(aggregatePosts)
            }
        }
    }
    
    public func getNotifications(completion : @escaping ([IGNotification]) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion([])
            return }
        
        let ref = database.collection("users").document(username).collection("notifications")
        ref.getDocuments { snapshot, error in
            guard let notifications = snapshot?.documents.compactMap({
                IGNotification(with: $0.data())
            }),
                  error == nil else {
                      completion([])
                      return
                  }
            completion(notifications)
        }
    }
    
    public func insertNotification(identifier : String, data : [String : Any], for username : String) {
        let ref = database.collection("users").document(username).collection("notifications").document(identifier)
        ref.setData(data)
    }
    
    public func getPosts(with identifier : String, from username : String, completion : @escaping (Post?) -> Void) {
        let ref = database.collection("users").document(username).collection("posts").document(identifier)
        ref.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return }
            
            completion(Post(with: data))
        }
    }
    
    enum RelationshipState {
        case unfollow
        case follow
    }
    
    public func updateRelationship(state : RelationshipState, for targetUsername : String, completion : @escaping (Bool) -> Void) {
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username ") else { return }
        
       
        let currentFollowing = database.collection("users").document(currentUsername).collection("following")
        
        let targetUserFollowers = database.collection("users").document(targetUsername).collection("followers")
   
        
        switch state {
        case .unfollow:
            currentFollowing.document(targetUsername).delete()
            targetUserFollowers.document(currentUsername).delete()
            completion(true)
        case .follow:
            currentFollowing.document(targetUsername).setData(["Valid":"1"])
            targetUserFollowers.document(currentUsername).setData(["Valid":"1"])
            completion(true)
        }
    }
}
