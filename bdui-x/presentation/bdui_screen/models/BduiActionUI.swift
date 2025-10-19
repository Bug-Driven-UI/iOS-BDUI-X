//
//  BduiActionUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

public struct PathModel: Equatable, Codable {
    public let value: String
    public init(_ value: String) { self.value = value }
}


public enum BduiRemoteActionModel: Equatable, Codable {
    case command(CommandModel)
    case updateScreen(UpdateScreenModel)

    public struct CommandModel: Equatable, Codable {
        public let type: String = "command"
        public let name: String
        public let params: [String: JSONValue]?
        private enum CodingKeys: String, CodingKey { case type, name, params }
        public init(name: String, params: [String: JSONValue]?) {
            self.name = name
            self.params = params
        }
    }

    public struct UpdateScreenModel: Equatable, Codable {
        public let type: String = "updateScreen"
        public let screenName: String
        public let screenNavigationParams: [String: JSONValue]?
        private enum CodingKeys: String, CodingKey { case type, screenName, screenNavigationParams }
        public init(screenName: String, screenNavigationParams: [String: JSONValue]?) {
            self.screenName = screenName
            self.screenNavigationParams = screenNavigationParams
        }
    }

    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable { case command, updateScreen }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .command: self = .command(try CommandModel(from: decoder))
        case .updateScreen: self = .updateScreen(try UpdateScreenModel(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .command(let v): try v.encode(to: encoder)
        case .updateScreen(let v): try v.encode(to: encoder)
        }
    }
}


public enum BduiInputValueChangedApplicableModel: Equatable, Codable {
    case sendRemoteActions(SendRemoteActionsModel)
    case setLocalStateFromInput(SetLocalStateFromInputModel)

    public struct SendRemoteActionsModel: Equatable, Codable {
        public let type: String = "sendRemoteActions"
        public let actions: [BduiRemoteActionModel]
        private enum CodingKeys: String, CodingKey { case type, actions }
        public init(actions: [BduiRemoteActionModel]) {
            self.actions = actions
        }
    }

    public struct SetLocalStateFromInputModel: Equatable, Codable {
        public let type: String = "setLocalStateFromInput"
        public let targetPath: PathModel
        private enum CodingKeys: String, CodingKey { case type, targetPath }
        public init(targetPath: PathModel) { self.targetPath = targetPath }
    }

    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable { case sendRemoteActions, setLocalStateFromInput }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .sendRemoteActions: self = .sendRemoteActions(try SendRemoteActionsModel(from: decoder))
        case .setLocalStateFromInput: self = .setLocalStateFromInput(try SetLocalStateFromInputModel(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .sendRemoteActions(let v): try v.encode(to: encoder)
        case .setLocalStateFromInput(let v): try v.encode(to: encoder)
        }
    }
}

public enum BduiActionUiModel: Equatable, Codable {
    case sendRemoteActions(BduiInputValueChangedApplicableModel.SendRemoteActionsModel)
    case navigateTo(NavigateToModel)
    case screenShown
    case screenRendered(ScreenRenderedModel)
    case errorScreenShown
    case componentClicked(ComponentClickedModel)
    case navigateBack(NavigateBackModel)
    case retry
    case inputValueChanged(InputValueChangedModel)
    case setLocalState(SetLocalStateModel)
    case updateScreenResultReceived

    public struct NavigateToModel: Equatable, Codable {
        public let type: String = "navigateTo"
        public let screenName: String
        public let screenNavigationParams: [String: JSONValue]?
        public let toBottomSheet: Bool
        private enum CodingKeys: String, CodingKey { case type, screenName, screenNavigationParams, toBottomSheet }
        public init(screenName: String, screenNavigationParams: [String: JSONValue]?, toBottomSheet: Bool = false) {
            self.screenName = screenName
            self.screenNavigationParams = screenNavigationParams
            self.toBottomSheet = toBottomSheet
        }
    }

    public struct ScreenRenderedModel: Equatable, Codable {
        public let type: String = "screenRendered"
        public let renderTimeMs: Int64
        public let screenVersion: Int
        public let components: [BduiComponentUiModel]
        private enum CodingKeys: String, CodingKey { case type, renderTimeMs, screenVersion, components }
        public init(renderTimeMs: Int64, screenVersion: Int, components: [BduiComponentUiModel]) {
            self.renderTimeMs = renderTimeMs
            self.screenVersion = screenVersion
            self.components = components
        }
    }

    public struct ComponentClickedModel: Equatable, Codable {
        public let type: String = "componentClicked"
        public let componentId: String
        private enum CodingKeys: String, CodingKey { case type, componentId }
        public init(componentId: String) { self.componentId = componentId }
    }

    public struct NavigateBackModel: Equatable, Codable {
        public let type: String = "navigateBack"
        public let updatePreviousScreen: Bool
        private enum CodingKeys: String, CodingKey { case type, updatePreviousScreen }
        public init(updatePreviousScreen: Bool = false) {
            self.updatePreviousScreen = updatePreviousScreen
        }
    }

    public struct InputValueChangedModel: Equatable, Codable {
        public let type: String = "inputValueChanged"
        public let actions: [BduiInputValueChangedApplicableModel]
        public let newInputValue: String
        private enum CodingKeys: String, CodingKey { case type, actions, newInputValue }
        public init(actions: [BduiInputValueChangedApplicableModel], newInputValue: String) {
            self.actions = actions
            self.newInputValue = newInputValue
        }
    }

    public struct SetLocalStateModel: Equatable, Codable {
        public let type: String = "setLocalState"
        public let targetPath: PathModel
        public let newValue: JSONValue
        private enum CodingKeys: String, CodingKey { case type, targetPath, newValue }
        public init(targetPath: PathModel, newValue: JSONValue) {
            self.targetPath = targetPath
            self.newValue = newValue
        }
    }

    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable {
        case sendRemoteActions, navigateTo, screenShown, screenRendered, errorScreenShown,
             componentClicked, navigateBack, retry, inputValueChanged, setLocalState, updateScreenResultReceived
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .sendRemoteActions:
            self = .sendRemoteActions(try BduiInputValueChangedApplicableModel.SendRemoteActionsModel(from: decoder))
        case .navigateTo:
            self = .navigateTo(try NavigateToModel(from: decoder))
        case .screenShown:
            self = .screenShown
        case .screenRendered:
            self = .screenRendered(try ScreenRenderedModel(from: decoder))
        case .errorScreenShown:
            self = .errorScreenShown
        case .componentClicked:
            self = .componentClicked(try ComponentClickedModel(from: decoder))
        case .navigateBack:
            self = .navigateBack(try NavigateBackModel(from: decoder))
        case .retry:
            self = .retry
        case .inputValueChanged:
            self = .inputValueChanged(try InputValueChangedModel(from: decoder))
        case .setLocalState:
            self = .setLocalState(try SetLocalStateModel(from: decoder))
        case .updateScreenResultReceived:
            self = .updateScreenResultReceived
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .sendRemoteActions(let v): try v.encode(to: encoder)
        case .navigateTo(let v): try v.encode(to: encoder)
        case .screenShown:
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(Discriminator.screenShown, forKey: .type)
        case .screenRendered(let v): try v.encode(to: encoder)
        case .errorScreenShown:
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(Discriminator.errorScreenShown, forKey: .type)
        case .componentClicked(let v): try v.encode(to: encoder)
        case .navigateBack(let v): try v.encode(to: encoder)
        case .retry:
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(Discriminator.retry, forKey: .type)
        case .inputValueChanged(let v): try v.encode(to: encoder)
        case .setLocalState(let v): try v.encode(to: encoder)
        case .updateScreenResultReceived:
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(Discriminator.updateScreenResultReceived, forKey: .type)
        }
    }
}
