//
//  NavigationArgs.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

struct BduiScreenArgs: Hashable, Codable {
    let screenId: String
    let screenParams: [String: JSONValue]
}

struct BduiBottomSheetArgs: Hashable, Codable {
    let screenId: String
    let screenParams: [String: JSONValue]
}
