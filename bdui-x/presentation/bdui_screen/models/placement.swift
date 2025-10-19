//
//  placement.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation
public enum BduiHorizontalArrangementModel: Equatable, Codable {
    case start, end, center, spaceBetween, spaceEvenly, spaceAround

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable { case start, end, center, spaceBetween, spaceEvenly, spaceAround }

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
        let k: Kind
        switch self {
        case .start: k = .start
        case .end: k = .end
        case .center: k = .center
        case .spaceBetween: k = .spaceBetween
        case .spaceEvenly: k = .spaceEvenly
        case .spaceAround: k = .spaceAround
        }
        try c.encode(k, forKey: .type)
    }
}
public enum BduiVerticalArrangementModel: Equatable, Codable {
    case top, bottom, center, spaceBetween, spaceEvenly, spaceAround

    private enum CodingKeys: String, CodingKey { case type }
    private enum Kind: String, Codable { case top, bottom, center, spaceBetween, spaceEvenly, spaceAround }

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
        let k: Kind
        switch self {
        case .top: k = .top
        case .bottom: k = .bottom
        case .center: k = .center
        case .spaceBetween: k = .spaceBetween
        case .spaceEvenly: k = .spaceEvenly
        case .spaceAround: k = .spaceAround
        }
        try c.encode(k, forKey: .type)
    }
}

public enum BduiHorizontalAlignmentModel: Equatable, Codable {
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
        let k: Kind = (self == .start ? .start : self == .center ? .center : .end)
        try c.encode(k, forKey: .type)
    }
}

public enum BduiVerticalAlignmentModel: Equatable, Codable {
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
        let k: Kind = (self == .top ? .top : self == .center ? .center : .bottom)
        try c.encode(k, forKey: .type)
    }
}

public enum BduiHorizontalAndVerticalAlignmentModel: Equatable, Codable {
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
        let k: Kind
        switch self {
        case .topStart: k = .topStart
        case .topCenter: k = .topCenter
        case .topEnd: k = .topEnd
        case .centerStart: k = .centerStart
        case .center: k = .center
        case .centerEnd: k = .centerEnd
        case .bottomStart: k = .bottomStart
        case .bottomCenter: k = .bottomCenter
        case .bottomEnd: k = .bottomEnd
        }
        try c.encode(k, forKey: .type)
    }
}
