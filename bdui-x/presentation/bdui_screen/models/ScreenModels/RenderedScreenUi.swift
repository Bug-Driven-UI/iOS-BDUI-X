//
//  RenderedScreenUi.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import Foundation

// MARK: - Rendered Screen

struct RenderedScreenUi: Equatable {
    let screenName: String
    let version: Int
    let components: [BduiComponentUI]
    let scaffold: BduiScaffoldUI?
    let isLoading: Bool

    func copy(
        components: [BduiComponentUI]? = nil,
        scaffold: BduiScaffoldUI?? = nil,
        isLoading: Bool? = nil
    ) -> RenderedScreenUi {
        RenderedScreenUi(
            screenName: screenName,
            version: version,
            components: components ?? self.components,
            scaffold: scaffold ?? self.scaffold,
            isLoading: isLoading ?? self.isLoading
        )
    }

    func withLoading(_ loading: Bool) -> RenderedScreenUi {
        copy(isLoading: loading)
    }
}

// MARK: - Hash Node for UpdateScreen requests

struct HashNode: Equatable {
    let id: String
    let hash: String
    let children: [HashNode]
}

struct ScreenDoActionResponseModel: Codable, Equatable {
    public let responses: [ActionResponseModel]

    public init(responses: [ActionResponseModel]) {
        self.responses = responses
    }

    private enum CodingKeys: String, CodingKey {
        case responses
    }
}

enum ActionResponseModel: Equatable, Codable {
    case command(Command)
    case updateScreen(UpdateScreen)

    private enum DiscriminatorKey: String, CodingKey { case type }
    private enum DiscriminatorValue: String { case command; case updateScreen }

    // MARK: - Command

    struct Command: Equatable, Codable {
        struct Response: Equatable, Codable {
            struct Data: Equatable, Codable {
                let component: RenderedComponent?
                let fallbackMessage: String?
                private enum CodingKeys: String, CodingKey { case component, fallbackMessage }
            }

            public let data: Data
            private enum CodingKeys: String, CodingKey { case data }
        }

        let name: String
        let response: Response
        private enum CodingKeys: String, CodingKey { case name, response }
    }

    // MARK: - UpdateScreen

    struct UpdateScreen: Equatable, Codable {
        struct Response: Equatable, Codable {
            struct Data: Equatable, Codable {
                enum ActionMethod: String, Codable { case update, insert, delete }
                let target: String
                let method: ActionMethod
                let content: RenderedComponent?
                private enum CodingKeys: String, CodingKey { case target, method, content }
            }

            public let data: [Data]
            private enum CodingKeys: String, CodingKey { case data }
        }

        public let response: Response
        private enum CodingKeys: String, CodingKey { case response }
    }

    // MARK: - Codable (полиморфия)

    public init(from decoder: Decoder) throws {
        let disc = try decoder.container(keyedBy: DiscriminatorKey.self)
        switch try disc.decode(String.self, forKey: .type) {
        case DiscriminatorValue.command.rawValue:
            self = try .command(Command(from: decoder))
        case DiscriminatorValue.updateScreen.rawValue:
            self = try .updateScreen(UpdateScreen(from: decoder))
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                    debugDescription: "Unknown type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var disc = encoder.container(keyedBy: DiscriminatorKey.self)
        switch self {
        case .command(let c):
            try disc.encode(DiscriminatorValue.command.rawValue, forKey: .type)
            try c.encode(to: encoder)
        case .updateScreen(let u):
            try disc.encode(DiscriminatorValue.updateScreen.rawValue, forKey: .type)
            try u.encode(to: encoder)
        }
    }
}

// MARK: - Action Requests (mirrors Kotlin ActionRequestModel)

enum ActionRequestModel {
    struct Command: Equatable {
        let name: String
        let params: [String: JSONValue]?
    }

    struct UpdateScreen: Equatable {
        let screenName: String
        let hashes: [HashNode]
        let screenNavigationParams: [String: JSONValue]?
    }

    enum AnyAction: Equatable {
        case command(Command)
        case updateScreen(UpdateScreen)
    }
}

struct ScreenDoActionRequestModel {
    let actions: [ActionRequestModel.AnyAction]
}
