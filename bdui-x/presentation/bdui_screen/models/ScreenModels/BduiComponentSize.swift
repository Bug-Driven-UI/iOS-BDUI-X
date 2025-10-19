//
//  BduiComponentSize.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import Foundation

public enum BduiComponentSizeModel: Equatable, Codable {
    case fixed(Int)
    case weighted(Double)
    case matchParent
    case wrapContent

    private enum CodingKeys: String, CodingKey { case type, value, fraction }
    private enum Discriminator: String, Codable { case fixed, weighted, matchParent, wrapContent }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .fixed: self = .fixed(try c.decode(Int.self, forKey: .value))
        case .weighted: self = .weighted(try c.decode(Double.self, forKey: .fraction))
        case .matchParent: self = .matchParent
        case .wrapContent: self = .wrapContent
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .fixed(let v):
            try c.encode(Discriminator.fixed, forKey: .type)
            try c.encode(v, forKey: .value)
        case .weighted(let f):
            try c.encode(Discriminator.weighted, forKey: .type)
            try c.encode(f, forKey: .fraction)
        case .matchParent:
            try c.encode(Discriminator.matchParent, forKey: .type)
        case .wrapContent:
            try c.encode(Discriminator.wrapContent, forKey: .type)
        }
    }
}
