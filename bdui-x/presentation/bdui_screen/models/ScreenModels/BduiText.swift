//
//  BduiText.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//


public struct BduiTextModel: Equatable, Codable {
    public let value: TextOrLocalStateModel
    public let color: BduiColorModel
    public let style: BduiTextStyleModel
    public let textAlignment: BduiTextAlignmentModel?
    public init(
        value: TextOrLocalStateModel,
        color: BduiColorModel,
        style: BduiTextStyleModel,
        textAlignment: BduiTextAlignmentModel?
    ) {
        self.value = value
        self.color = color
        self.style = style
        self.textAlignment = textAlignment
    }
}
