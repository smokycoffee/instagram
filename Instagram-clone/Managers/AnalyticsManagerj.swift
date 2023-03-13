//
//  AnalyticsManagerj.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    
    static let shared = AnalyticsManager() // singleton
    
    private init() {}
    
    func logEvent() {
        Analytics.logEvent("", parameters: [:])
    }
}

