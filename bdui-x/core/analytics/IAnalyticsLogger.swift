//
//  IAnalyticsLogger.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public protocol IAnalyticsLogger {
    func logEvent(eventName: String, params: [String: String])
}