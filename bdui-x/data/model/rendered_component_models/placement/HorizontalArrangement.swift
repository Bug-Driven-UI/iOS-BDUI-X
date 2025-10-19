//
//  RenderedHorizontalArrangement.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation


public enum RenderedHorizontalArrangement: Equatable, Codable {
    case start, end, center, spaceBetween, spaceEvenly, spaceAround

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable {
        case start, end, center, spaceBetween, spaceEvenly, spaceAround
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Kind.self, forKey: .type) {
        case .start: self = .start
        case .end: self = .end
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
        case .start: kind = .start
        case .end: kind = .end
        case .center: kind = .center
        case .spaceBetween: kind = .spaceBetween
        case .spaceEvenly: kind = .spaceEvenly
        case .spaceAround: kind = .spaceAround
        }
        try c.encode(kind, forKey: .type)
    }
}


public enum RenderedHorizontalAndVerticalAlignment: Equatable, Codable {
    case topStart, topCenter, topEnd
    case centerStart, center, centerEnd
    case bottomStart, bottomCenter, bottomEnd

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable {
        case topStart, topCenter, topEnd
        case centerStart, center, centerEnd
        case bottomStart, bottomCenter, bottomEnd
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Kind.self, forKey: .type) {
        case .topStart: self = .topStart
        case .topCenter: self = .topCenter
        case .topEnd: self = .topEnd
        case .centerStart: self = .centerStart
        case .center: self = .center
        case .centerEnd: self = .centerEnd
        case .bottomStart: self = .bottomStart
        case .bottomCenter: self = .bottomCenter
        case .bottomEnd: self = .bottomEnd
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        let kind: Kind
        switch self {
        case .topStart: kind = .topStart
        case .topCenter: kind = .topCenter
        case .topEnd: kind = .topEnd
        case .centerStart: kind = .centerStart
        case .center: kind = .center
        case .centerEnd: kind = .centerEnd
        case .bottomStart: kind = .bottomStart
        case .bottomCenter: kind = .bottomCenter
        case .bottomEnd: kind = .bottomEnd
        }
        try c.encode(kind, forKey: .type)
    }
}


