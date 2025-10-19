//
//  BduiComponentUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import Foundation


// MARK: - Component type

public enum BduiComponentUiModel: Equatable, Codable {
    case textModel(BduiTextComponentModel)
    case imageModel(BduiImageComponentModel)
    case buttonModel(BduiButtonComponentModel)
    case inputModel(BduiInputComponentModel)
    case spacerModel(BduiSpacerComponentModel)
    case rowModel(BduiRowComponentModel)
    case columnModel(BduiColumnComponentModel)
    case boxModel(BduiBoxComponentModel)

    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable { case text, image, button, input, spacer, row, column, box }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .text: self = .textModel(try BduiTextComponentModel(from: decoder))
        case .image: self = .imageModel(try BduiImageComponentModel(from: decoder))
        case .button: self = .buttonModel(try BduiButtonComponentModel(from: decoder))
        case .input: self = .inputModel(try BduiInputComponentModel(from: decoder))
        case .spacer: self = .spacerModel(try BduiSpacerComponentModel(from: decoder))
        case .row: self = .rowModel(try BduiRowComponentModel(from: decoder))
        case .column: self = .columnModel(try BduiColumnComponentModel(from: decoder))
        case .box: self = .boxModel(try BduiBoxComponentModel(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .textModel(let v): try v.encode(to: encoder)
        case .imageModel(let v): try v.encode(to: encoder)
        case .buttonModel(let v): try v.encode(to: encoder)
        case .inputModel(let v): try v.encode(to: encoder)
        case .spacerModel(let v): try v.encode(to: encoder)
        case .rowModel(let v): try v.encode(to: encoder)
        case .columnModel(let v): try v.encode(to: encoder)
        case .boxModel(let v): try v.encode(to: encoder)
        }
    }
}

// MARK: - Leaf components (renamed types)

public struct BduiTextComponentModel: Equatable, Codable {
    public let type: String = "text"
    public let baseProperties: BduiBasePropertiesModel
    public let text: BduiTextModel
    private enum CodingKeys: String, CodingKey { case type, baseProperties, text }
    public init(baseProperties: BduiBasePropertiesModel, text: BduiTextModel) {
        self.baseProperties = baseProperties
        self.text = text
    }
}

public struct BduiImageComponentModel: Equatable, Codable {
    public let type: String = "image"
    public let baseProperties: BduiBasePropertiesModel
    public let imageUrl: String
    private enum CodingKeys: String, CodingKey { case type, baseProperties, imageUrl }
    public init(baseProperties: BduiBasePropertiesModel, imageUrl: String) {
        self.baseProperties = baseProperties
        self.imageUrl = imageUrl
    }
}

public struct BduiButtonComponentModel: Equatable, Codable {
    public let type: String = "button"
    public let baseProperties: BduiBasePropertiesModel
    public let text: BduiTextComponentModel
    public let enabled: Bool
    private enum CodingKeys: String, CodingKey { case type, baseProperties, text, enabled }
    public init(baseProperties: BduiBasePropertiesModel, text: BduiTextComponentModel, enabled: Bool) {
        self.baseProperties = baseProperties
        self.text = text
        self.enabled = enabled
    }
}

public struct BduiInputComponentModel: Equatable, Codable {
    public let type: String = "input"
    public let baseProperties: BduiBasePropertiesModel
    public let text: BduiTextModel
    public let placeholder: BduiTextModel?
    public let rightIcon: BduiImageComponentModel?
    public let onValueChangedActions: [BduiInputValueChangedApplicableModel]
    private enum CodingKeys: String, CodingKey { case type, baseProperties, text, placeholder, rightIcon, onValueChangedActions }
    public init(
        baseProperties: BduiBasePropertiesModel,
        text: BduiTextModel,
        placeholder: BduiTextModel?,
        rightIcon: BduiImageComponentModel?,
        onValueChangedActions: [BduiInputValueChangedApplicableModel]
    ) {
        self.baseProperties = baseProperties
        self.text = text
        self.placeholder = placeholder
        self.rightIcon = rightIcon
        self.onValueChangedActions = onValueChangedActions
    }
}

public struct BduiSpacerComponentModel: Equatable, Codable {
    public let type: String = "spacer"
    public let baseProperties: BduiBasePropertiesModel
    private enum CodingKeys: String, CodingKey { case type, baseProperties }
    public init(baseProperties: BduiBasePropertiesModel) {
        self.baseProperties = baseProperties
    }
}

// MARK: - Containers (renamed types)

public struct BduiRowComponentModel: Equatable, Codable {
    public let type: String = "row"
    public let horizontalArrangement: BduiHorizontalArrangementModel?
    public let verticalAlignment: BduiVerticalAlignmentModel?
    public let isScrollable: Bool
    public let baseProperties: BduiBasePropertiesModel
    public let children: [BduiComponentUiModel]
    private enum CodingKeys: String, CodingKey { case type, horizontalArrangement, verticalAlignment, isScrollable, baseProperties, children }
    public init(
        horizontalArrangement: BduiHorizontalArrangementModel?,
        verticalAlignment: BduiVerticalAlignmentModel?,
        isScrollable: Bool = false,
        baseProperties: BduiBasePropertiesModel,
        children: [BduiComponentUiModel]
    ) {
        self.horizontalArrangement = horizontalArrangement
        self.verticalAlignment = verticalAlignment
        self.isScrollable = isScrollable
        self.baseProperties = baseProperties
        self.children = children
    }
}

public struct BduiColumnComponentModel: Equatable, Codable {
    public let type: String = "column"
    public let verticalArrangement: BduiVerticalArrangementModel?
    public let horizontalAlignment: BduiHorizontalAlignmentModel?
    public let baseProperties: BduiBasePropertiesModel
    public let children: [BduiComponentUiModel]
    private enum CodingKeys: String, CodingKey { case type, verticalArrangement, horizontalAlignment, baseProperties, children }
    public init(
        verticalArrangement: BduiVerticalArrangementModel?,
        horizontalAlignment: BduiHorizontalAlignmentModel?,
        baseProperties: BduiBasePropertiesModel,
        children: [BduiComponentUiModel]
    ) {
        self.verticalArrangement = verticalArrangement
        self.horizontalAlignment = horizontalAlignment
        self.baseProperties = baseProperties
        self.children = children
    }
}

public struct BduiBoxComponentModel: Equatable, Codable {
    public let type: String = "box"
    public let contentAlignment: BduiHorizontalAndVerticalAlignmentModel?
    public let baseProperties: BduiBasePropertiesModel
    public let children: [BduiComponentUiModel]
    private enum CodingKeys: String, CodingKey { case type, contentAlignment, baseProperties, children }
    public init(
        contentAlignment: BduiHorizontalAndVerticalAlignmentModel?,
        baseProperties: BduiBasePropertiesModel,
        children: [BduiComponentUiModel]
    ) {
        self.contentAlignment = contentAlignment
        self.baseProperties = baseProperties
        self.children = children
    }
}
