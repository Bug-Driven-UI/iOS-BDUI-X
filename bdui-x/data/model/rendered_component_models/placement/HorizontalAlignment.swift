//
//  RenderedHorizontalAlignment.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public enum RenderedHorizontalAlignment: Equatable, Codable {
    case start, center, end

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable { case start, center, end }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Kind.self, forKey: .type) {
        case .start: self = .start
        case .center: self = .center
        case .end: self = .end
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        let kind: Kind = (self == .start ? .start : self == .center ? .center : .end)
        try c.encode(kind, forKey: .type)
    }
}
