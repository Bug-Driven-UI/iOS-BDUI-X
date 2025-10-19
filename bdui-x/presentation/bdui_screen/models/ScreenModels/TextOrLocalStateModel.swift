//
//  TextOrLocalStateModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

public enum TextOrLocalStateModel: Equatable, Codable {
    case text(String)
    case localState(path: String)

    private enum CodingKeys: String, CodingKey { case type, value, path }
    private enum Discriminator: String, Codable { case text, localState }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .text: self = try .text(c.decode(String.self, forKey: .value))
        case .localState: self = try .localState(path: c.decode(String.self, forKey: .path))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let v):
            try c.encode(Discriminator.text, forKey: .type)
            try c.encode(v, forKey: .value)
        case .localState(let path):
            try c.encode(Discriminator.localState, forKey: .type)
            try c.encode(path, forKey: .path)
        }
    }
}
