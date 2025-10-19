//
//  RenderedScreenUiModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public struct RenderedScreenUiModel: Equatable, Codable {
    public let screenName: String
    public let version: Int
    public let components: [BduiComponentUiModel]
    public let scaffold: BduiScaffoldUiModel?
    public let isLoading: Bool

    public init(
        screenName: String,
        version: Int,
        components: [BduiComponentUiModel],
        scaffold: BduiScaffoldUiModel?,
        isLoading: Bool = false
    ) {
        self.screenName = screenName
        self.version = version
        self.components = components
        self.scaffold = scaffold
        self.isLoading = isLoading
    }
}