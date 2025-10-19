//
//  MockAnalyticsLogger.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation

public final class MockAnalyticsLogger: IAnalyticsLogger {
    public private(set) var events: [(name: String, params: [String: String])] = []

    public init() {}

    public func logEvent(eventName: String, params: [String: String]) {
        events.append((eventName, params))
        
        #if DEBUG
        print("MockAnalyticsLogger -> \(eventName): \(params)")
        #endif
    }
}
