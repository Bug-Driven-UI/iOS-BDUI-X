//
//  RenderedSize.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum RenderedSizeModel: Codable {
    case fixed(value: Int)
    case weighted(fraction: Float)
    case matchParent
    case wrapContent

    private enum CodingKeys: String, CodingKey {
        case type, value, fraction
    }

    private enum TypeValue: String, Codable {
        case fixed, weighted, matchParent, wrapContent
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(TypeValue.self, forKey: .type) {
        case .fixed:
            let v = try c.decode(Int.self, forKey: .value)
            self = .fixed(value: v)
        case .weighted:
            let f = try c.decode(Float.self, forKey: .fraction)
            self = .weighted(fraction: f)
        case .matchParent:
            self = .matchParent
        case .wrapContent:
            self = .wrapContent
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .fixed(let value):
            try c.encode(TypeValue.fixed, forKey: .type)
            try c.encode(value, forKey: .value)
        case .weighted(let fraction):
            try c.encode(TypeValue.weighted, forKey: .type)
            try c.encode(fraction, forKey: .fraction)
        case .matchParent:
            try c.encode(TypeValue.matchParent, forKey: .type)
        case .wrapContent:
            try c.encode(TypeValue.wrapContent, forKey: .type)
        }
    }
}
