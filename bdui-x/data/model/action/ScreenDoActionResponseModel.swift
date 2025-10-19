//
//  ScreenDoActionResponseModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation

public struct ScreenDoActionResponseModel: Codable, Equatable {
    public let responses: [ActionResponseModel]

    public init(responses: [ActionResponseModel]) {
        self.responses = responses
    }
}

// MARK: - ActionResponseModel (sealed interface with discriminator "type")

public enum ActionResponseModel: Equatable, Codable {
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
            self = .command(try CommandModel(from: decoder))
        case .updateScreen:
            self = .updateScreen(try UpdateScreenModel(from: decoder))
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
        public let response: Response

        private enum CodingKeys: String, CodingKey { case type, name, response }

        public init(name: String, response: Response) {
            self.name = name
            self.response = response
        }

        public struct Response: Codable, Equatable {
            public let data: Data
            public init(data: Data) { self.data = data }

            public struct Data: Codable, Equatable {
                public let component: RenderedComponentModel?
                public let fallbackMessage: String?

                public init(component: RenderedComponentModel? = nil, fallbackMessage: String? = nil) {
                    self.component = component
                    self.fallbackMessage = fallbackMessage
                }
            }
        }
    }

    public struct UpdateScreenModel: Codable, Equatable {
        public let type: String = "updateScreen"
        public let response: Response

        private enum CodingKeys: String, CodingKey { case type, response }

        public init(response: Response) {
            self.response = response
        }

        public struct Response: Codable, Equatable {
            public let screen: [PatchData]
            public let topBar: [PatchData]?
            public let bottomBar: [PatchData]?

            public init(screen: [PatchData], topBar: [PatchData]? = nil, bottomBar: [PatchData]? = nil) {
                self.screen = screen
                self.topBar = topBar
                self.bottomBar = bottomBar
            }

            public struct PatchData: Codable, Equatable {
                public let target: String
                public let method: ActionMethod
                public let content: RenderedComponentModel?

                public init(target: String, method: ActionMethod, content: RenderedComponentModel? = nil) {
                    self.target = target
                    self.method = method
                    self.content = content
                }

                public enum ActionMethod: String, Codable, Equatable {
                    case update = "update"
                    case insert = "insert"
                    case delete = "delete"
                }
            }
        }
    }
}

// MARK: - Bridging helpers (optional)
// If you already use UpdateScreenResponseModel and UpdateScreenPatchDataModel elsewhere,
// these helpers convert the enum payload into those structures so you can keep existing code.

public extension ActionResponseModel.UpdateScreenModel.Response.PatchData {
    func toUpdateScreenPatchDataModel() -> UpdateScreenPatchDataModel {
        let m: UpdateScreenPatchDataModel.ActionMethodModel
        switch method {
        case .insert: m = .insert
        case .update: m = .update
        case .delete: m = .delete
        }
        return UpdateScreenPatchDataModel(target: target, method: m, content: content)
    }
}

