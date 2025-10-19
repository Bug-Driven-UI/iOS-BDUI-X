//
//  BduiScaffoldUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//


import SwiftUI

public struct BduiScaffoldUiModel: Equatable, Codable {
    public let topBar: BduiComponentUiModel?
    public let bottomBar: BduiComponentUiModel?

    public init(
        topBar: BduiComponentUiModel?,
        bottomBar: BduiComponentUiModel?
    ) {
        self.topBar = topBar
        self.bottomBar = bottomBar
    }
}
