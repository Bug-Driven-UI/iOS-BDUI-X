//
//  RenderedVerticalAlignment.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public enum RenderedVerticalAlignment: Equatable, Codable {
    case top, center, bottom

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable { case top, center, bottom }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Kind.self, forKey: .type) {
        case .top: self = .top
        case .center: self = .center
        case .bottom: self = .bottom
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        let kind: Kind = (self == .top ? .top : self == .center ? .center : .bottom)
        try c.encode(kind, forKey: .type)
    }
}
