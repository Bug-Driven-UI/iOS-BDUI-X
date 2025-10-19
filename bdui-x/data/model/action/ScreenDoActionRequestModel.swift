//
//  ScreenDoActionRequestModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

public struct ScreenDoActionRequestModel: Codable, Equatable {
    public let actions: [ActionRequestModel]

    public init(actions: [ActionRequestModel]) {
        self.actions = actions
    }
}



public enum ActionRequestModel: Equatable, Codable {
    case command(CommandModel)
    case updateScreen(UpdateScreenModel)

    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable {
        case command
        case updateScreen
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .command:
            self = try .command(CommandModel(from: decoder))
        case .updateScreen:
            self = try .updateScreen(UpdateScreenModel(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .command(let v): try v.encode(to: encoder)
        case .updateScreen(let v): try v.encode(to: encoder)
        }
    }

    // MARK: - Variants

    public struct CommandModel: Codable, Equatable {
        public let type: String = "command"
        public let name: String
        public let params: [String: JSONValue]?

        private enum CodingKeys: String, CodingKey { case type, name, params }

        public init(name: String, params: [String: JSONValue]? = nil) {
            self.name = name
            self.params = params
        }
    }

    public struct UpdateScreenModel: Codable, Equatable {
        public let type: String = "updateScreen"
        public let screenName: String
        public let screen: ScreenHashes
        public let topBar: ScreenPartHashes?
        public let bottomBar: ScreenPartHashes?
        public let screenNavigationParams: [String: JSONValue]?

        private enum CodingKeys: String, CodingKey {
            case type, screenName, screen, topBar, bottomBar, screenNavigationParams
        }

        public init(
            screenName: String,
            screen: ScreenHashes,
            topBar: ScreenPartHashes? = nil,
            bottomBar: ScreenPartHashes? = nil,
            screenNavigationParams: [String: JSONValue]? = nil
        ) {
            self.screenName = screenName
            self.screen = screen
            self.topBar = topBar
            self.bottomBar = bottomBar
            self.screenNavigationParams = screenNavigationParams
        }

        // Nested models

        public struct ScreenHashes: Codable, Equatable {
            public let hashes: [HashNodeModel]
            public init(hashes: [HashNodeModel]) { self.hashes = hashes }
        }

        public struct ScreenPartHashes: Codable, Equatable {
            public let hashNode: HashNodeModel
            public init(hashNode: HashNodeModel) { self.hashNode = hashNode }
        }
    }
}



public struct HashNodeModel: Codable, Equatable {
    public let id: String
    public let hash: String
    public let children: [HashNodeModel]

    public init(id: String, hash: String, children: [HashNodeModel] = []) {
        self.id = id
        self.hash = hash
        self.children = children
    }
}
