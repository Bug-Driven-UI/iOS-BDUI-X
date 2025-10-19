//
//  RenderedVerticalArrangement.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public enum RenderedVerticalArrangement: Equatable, Codable {
    case top, bottom, center, spaceBetween, spaceEvenly, spaceAround

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable {
        case top, bottom, center, spaceBetween, spaceEvenly, spaceAround
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Kind.self, forKey: .type) {
        case .top: self = .top
        case .bottom: self = .bottom
        case .center: self = .center
        case .spaceBetween: self = .spaceBetween
        case .spaceEvenly: self = .spaceEvenly
        case .spaceAround: self = .spaceAround
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        let kind: Kind
        switch self {
        case .top: kind = .top
        case .bottom: kind = .bottom
        case .center: kind = .center
        case .spaceBetween: kind = .spaceBetween
        case .spaceEvenly: kind = .spaceEvenly
        case .spaceAround: kind = .spaceAround
        }
        try c.encode(kind, forKey: .type)
    }
}
