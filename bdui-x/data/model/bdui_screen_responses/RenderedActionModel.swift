//
//  RenderedAction.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum RenderedActionModel: Codable {
    case command(Command)
    case updateScreen(UpdateScreen)

    private enum CodingKeys: String, CodingKey { case type }
    private enum TypeValue: String, Codable { case command, updateScreen }

    struct Command: Codable {
        let name: String
        let params: [String: JSONValue]?
    }

    struct UpdateScreen: Codable {
        let screenName: String
        let screenNavigationParams: [String: JSONValue]?
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(TypeValue.self, forKey: .type) {
        case .command: self = .command(try Command(from: decoder))
        case .updateScreen: self = .updateScreen(try UpdateScreen(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .command(let v):
            try c.encode(TypeValue.command, forKey: .type)
            try v.encode(to: encoder)
        case .updateScreen(let v):
            try c.encode(TypeValue.updateScreen, forKey: .type)
            try v.encode(to: encoder)
        }
    }
}
