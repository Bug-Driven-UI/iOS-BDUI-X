//
//  BduiComponentBaseProperties.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

public struct BduiBasePropertiesModel: Equatable, Codable {
    public let id: String
    public let hash: String
    public let interactions: BduiComponentInteractionsUiModel?
    public let paddings: BduiComponentInsetsUiModel?
    public let margins: BduiComponentInsetsUiModel?
    public let width: BduiComponentSizeModel
    public let height: BduiComponentSizeModel
    public let backgroundColor: BduiColorModel?
    public let border: BduiBorderModel?
    public let shape: BduiShapeModel?

    public init(
        id: String,
        hash: String,
        interactions: BduiComponentInteractionsUiModel?,
        paddings: BduiComponentInsetsUiModel?,
        margins: BduiComponentInsetsUiModel?,
        width: BduiComponentSizeModel,
        height: BduiComponentSizeModel,
        backgroundColor: BduiColorModel?,
        border: BduiBorderModel?,
        shape: BduiShapeModel?
    ) {
        self.id = id
        self.hash = hash
        self.interactions = interactions
        self.paddings = paddings
        self.margins = margins
        self.width = width
        self.height = height
        self.backgroundColor = backgroundColor
        self.border = border
        self.shape = shape
    }
}
