//
//  BduiComponentInsetsUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

public struct BduiComponentInsetsUiModel: Equatable, Codable {
    public let start: Int
    public let end: Int
    public let top: Int
    public let bottom: Int
    public init(start: Int, end: Int, top: Int, bottom: Int) {
        self.start = start
        self.end = end
        self.top = top
        self.bottom = bottom
    }
}
