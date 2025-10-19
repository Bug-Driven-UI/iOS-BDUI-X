//
//  NavigationArgs.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

public struct BduiScreenArgs: Hashable, Codable {
    public let screenName: String
    public let screenParams: [String: JSONValue]?

    public init(screenName: String, screenParams: [String: JSONValue]?) {
        self.screenName = screenName
        self.screenParams = screenParams
    }
}

public struct BduiBottomSheetArgs: Hashable, Codable {
    public let screenName: String
    public let screenParams: [String: JSONValue]?

    public init(screenName: String, screenParams: [String: JSONValue]?) {
        self.screenName = screenName
        self.screenParams = screenParams
    }
}
