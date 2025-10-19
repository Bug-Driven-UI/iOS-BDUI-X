//
//  RenderedScreenResponseModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

// MARK: - Top-level responses

public struct RenderedScreenResponseModel: Codable, Equatable {
    public let screen: RenderedScreenModel

    enum CodingKeys: String, CodingKey {
        case screen
    }
}

public struct RenderedScreenModel: Codable, Equatable {
    public let screenName: String
    public let version: Int
    public let components: [RenderedComponentModel]
    public let scaffold: RenderedScaffoldModel?
    public let localStates: [String: JSONValue]?

    enum CodingKeys: String, CodingKey {
        case screenName
        case version
        case components
        case scaffold
        case localStates
    }
}

public struct RenderedScaffoldModel: Codable, Equatable {
    public let topBar: RenderedComponentModel?
    public let bottomBar: RenderedComponentModel?

    enum CodingKeys: String, CodingKey {
        case topBar
        case bottomBar
    }
}


// MARK: - Interactions and Actions

public struct RenderedInteractionModel: Codable, Equatable {
    public let type: InteractionType
    public let actions: [RenderedActionModel]

    public enum InteractionType: String, Codable, Equatable {
        case onClick
        case onShow
    }
}

public enum RenderedActionModel: Equatable {
    case command(RenderedCommandActionModel)
    case updateScreen(RenderedUpdateScreenActionModel)
    case navigateTo(RenderedNavigateToActionModel)
    case navigateToBottomSheet(RenderedNavigateToBottomSheetActionModel)
    case navigateBack(RenderedNavigateBackActionModel)
    case setLocalStateFromInput(RenderedSetLocalStateFromInputActionModel)
    case setLocalState(RenderedSetLocalStateActionModel)
}

extension RenderedActionModel: Codable {
    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable {
        case command
        case updateScreen
        case navigateTo
        case navigateToBottomSheet
        case navigateBack
        case setLocalStateFromInput
        case setLocalState
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(Discriminator.self, forKey: .type)
        let single = try decoder.singleValueContainer()

        switch t {
        case .command:
            self = try .command(single.decode(RenderedCommandActionModel.self))
        case .updateScreen:
            self = try .updateScreen(single.decode(RenderedUpdateScreenActionModel.self))
        case .navigateTo:
            self = try .navigateTo(single.decode(RenderedNavigateToActionModel.self))
        case .navigateToBottomSheet:
            self = try .navigateToBottomSheet(single.decode(RenderedNavigateToBottomSheetActionModel.self))
        case .navigateBack:
            self = try .navigateBack(single.decode(RenderedNavigateBackActionModel.self))
        case .setLocalStateFromInput:
            self = try .setLocalStateFromInput(single.decode(RenderedSetLocalStateFromInputActionModel.self))
        case .setLocalState:
            self = try .setLocalState(single.decode(RenderedSetLocalStateActionModel.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .command(let v):
            try v.encode(to: encoder)
        case .updateScreen(let v):
            try v.encode(to: encoder)
        case .navigateTo(let v):
            try v.encode(to: encoder)
        case .navigateToBottomSheet(let v):
            try v.encode(to: encoder)
        case .navigateBack(let v):
            try v.encode(to: encoder)
        case .setLocalStateFromInput(let v):
            try v.encode(to: encoder)
        case .setLocalState(let v):
            try v.encode(to: encoder)
        }
    }
}


public struct RenderedCommandActionModel: Codable, Equatable {
    public let type: String = "command"
    public let name: String
    public let params: [String: JSONValue]?

    enum CodingKeys: String, CodingKey { case type, name, params }
}

public struct RenderedUpdateScreenActionModel: Codable, Equatable {
    public let type: String = "updateScreen"
    public let screenName: String
    public let screenNavigationParams: [String: JSONValue]?

    enum CodingKeys: String, CodingKey { case type, screenName, screenNavigationParams }
}

public struct RenderedNavigateToActionModel: Codable, Equatable {
    public let type: String = "navigateTo"
    public let screenName: String
    public let screenNavigationParams: [String: JSONValue]?

    enum CodingKeys: String, CodingKey { case type, screenName, screenNavigationParams }
}

public struct RenderedNavigateToBottomSheetActionModel: Codable, Equatable {
    public let type: String = "navigateToBottomSheet"
    public let screenName: String
    public let screenNavigationParams: [String: JSONValue]?

    enum CodingKeys: String, CodingKey { case type, screenName, screenNavigationParams }
}

public struct RenderedNavigateBackActionModel: Codable, Equatable {
    public let type: String = "navigateBack"
    public let updatePreviousScreen: Bool

    enum CodingKeys: String, CodingKey { case type, updatePreviousScreen }
}

public struct RenderedSetLocalStateFromInputActionModel: Codable, Equatable {
    public let type: String = "setLocalStateFromInput"
    public let target: String

    enum CodingKeys: String, CodingKey { case type, target }
}

public struct RenderedSetLocalStateActionModel: Codable, Equatable {
    public let type: String = "setLocalState"
    public let target: String
    public let value: JSONValue 

    enum CodingKeys: String, CodingKey { case type, target, value }
}

// MARK: - Common UI models

public struct RenderedInsetsModel: Codable, Equatable {
    public let start: Int
    public let end: Int
    public let bottom: Int
    public let top: Int
}

public enum RenderedSizeModel: Equatable {
    case fixed(RenderedSizeFixedModel)
    case weighted(RenderedSizeWeightedModel)
    case matchParent
    case wrapContent
}

extension RenderedSizeModel: Codable {
    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable {
        case fixed
        case weighted
        case matchParent
        case wrapContent
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(Discriminator.self, forKey: .type)
        switch t {
        case .fixed:
            self = try .fixed(RenderedSizeFixedModel(from: decoder))
        case .weighted:
            self = try .weighted(RenderedSizeWeightedModel(from: decoder))
        case .matchParent:
            self = .matchParent
        case .wrapContent:
            self = .wrapContent
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .fixed(let v):
            try v.encode(to: encoder)
        case .weighted(let v):
            try v.encode(to: encoder)
        case .matchParent:
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(Discriminator.matchParent, forKey: .type)
        case .wrapContent:
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(Discriminator.wrapContent, forKey: .type)
        }
    }
}

public struct RenderedSizeFixedModel: Codable, Equatable {
    public let type: String = "fixed"
    public let value: Int
    enum CodingKeys: String, CodingKey { case type, value }
}

public struct RenderedSizeWeightedModel: Codable, Equatable {
    public let type: String = "weighted"
    public let fraction: Float
    enum CodingKeys: String, CodingKey { case type, fraction }
}

public struct RenderedColorStyleModel: Codable, Equatable {
    public let hex: String
}

public struct RenderedBorderModel: Codable, Equatable {
    public let color: RenderedColorStyleModel
    public let thickness: Int
}

public struct RenderedShapeModel: Codable, Equatable {
    public let type: ShapeType
    public let topRight: Int
    public let topLeft: Int
    public let bottomRight: Int
    public let bottomLeft: Int

    public enum ShapeType: String, Codable, Equatable {
        case roundedCorners
    }
}

public struct RenderedStyledTextRepresentationModel: Codable, Equatable {
    public let textOrLocalState: String
    public let textStyle: RenderedTextStyleModel
    public let textColorStyle: RenderedColorStyleModel
    public let textAlignment: TextAlignmentModel?

    public enum TextAlignmentModel: String, Codable, Equatable {
        case start
        case center
        case end
    }

    private enum CodingKeys: String, CodingKey {
        case textOrLocalState = "text"
        case textStyle
        case textColorStyle = "colorStyle"
        case textAlignment
    }
}

public struct RenderedTextStyleModel: Codable, Equatable {
    public let decoration: RenderedTextDecorationTypeModel?
    public let weight: Int?
    public let size: Int
    public let lineHeight: Int
}

public enum RenderedTextDecorationTypeModel: String, Codable, Equatable {
    case italic
    case underline
    case strikethrough = "strikeThrough"
    case strikethroughRed = "strikeThroughRed"
    case regular
}

public enum RenderedBadgeModel: Equatable {
    case badgeWithImage(RenderedBadgeWithImageModel)
    case badgeWithText(RenderedBadgeWithTextModel)
}

extension RenderedBadgeModel: Codable {
    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable {
        case badgeWithImage
        case badgeWithText
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(Discriminator.self, forKey: .type)
        switch t {
        case .badgeWithImage:
            self = try .badgeWithImage(RenderedBadgeWithImageModel(from: decoder))
        case .badgeWithText:
            self = try .badgeWithText(RenderedBadgeWithTextModel(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .badgeWithImage(let v):
            try v.encode(to: encoder)
        case .badgeWithText(let v):
            try v.encode(to: encoder)
        }
    }
}

public struct RenderedBadgeWithImageModel: Codable, Equatable {
    public let type: String = "badgeWithImage"
    public let imageUrl: String
    enum CodingKeys: String, CodingKey { case type, imageUrl }
}

public struct RenderedBadgeWithTextModel: Codable, Equatable {
    public let type: String = "badgeWithText"
    public let textWithStyle: RenderedStyledTextRepresentationModel
    enum CodingKeys: String, CodingKey { case type, textWithStyle }
}

public enum RenderedRegexModel: String, Codable, Equatable {
    case email
}

public struct RenderedPlaceholderModel: Codable, Equatable {
    public let textWithStyle: RenderedStyledTextRepresentationModel
}

public struct RenderedHintModel: Codable, Equatable {
    public let textWithStyle: RenderedStyledTextRepresentationModel
}
