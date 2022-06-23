//
//  AnalyticsManager.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent() {
        Analytics.logEvent("", parameters: [:])
    }
}
