//
//  NotificationManager.swift
//  InstagramClone
//
//  Created by Admin on 4/19/22.
//

import Foundation

final class NotificationManager {
    static let shared = NotificationManager()
    
    enum IGType : Int {
        case like = 1
        case comment = 2
        case follow = 3
    }
    
    private init () { }
    
    static func newIdentifier() -> String {
        let date = Date()
        let number1 = Int.random(in: 0...1000)
        let number2 = Int.random(in: 0...1000)
        return "\(number1)_\(number2)_\(date.timeIntervalSince1970)"
    }
    
    public func getNotifications(completion : @escaping ([IGNotification]) -> Void) {
        DatabaseManager.shared.getNotifications(completion: completion)
    }
    
    public func create(notification : IGNotification, for username : String) {
        guard let dictionary = notification.asDictionary() else { return }
        let identifier = notification.identifier
        
        DatabaseManager.shared.insertNotification(identifier: identifier, data: dictionary, for: username)
    }
}

