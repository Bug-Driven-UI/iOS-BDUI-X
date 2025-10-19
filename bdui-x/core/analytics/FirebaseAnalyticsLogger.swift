//
//  FirebaseAnalyticsLogger.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation
import FirebaseAnalytics

public final class FirebaseAnalyticsLogger: IAnalyticsLogger {
    public init() {}

    public func logEvent(eventName: String, params: [String: String]) {
        Analytics.logEvent(eventName, parameters: params)
    }
}
