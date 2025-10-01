//
//  RenderedBadge.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum RenderedBadgeModel: Codable {
    case badgeWithImage(BadgeWithImage)
    case badgeWithText(BadgeWithText)

    private enum CodingKeys: String, CodingKey { case type }
    private enum TypeValue: String, Codable { case badgeWithImage, badgeWithText }

    struct BadgeWithImage: Codable { let imageUrl: String }
    struct BadgeWithText: Codable { let textWithStyle: RenderedStyledTextRepresentationModel }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(TypeValue.self, forKey: .type) {
        case .badgeWithImage: self = .badgeWithImage(try BadgeWithImage(from: decoder))
        case .badgeWithText: self = .badgeWithText(try BadgeWithText(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .badgeWithImage(let v):
            try c.encode(TypeValue.badgeWithImage, forKey: .type)
            try v.encode(to: encoder)
        case .badgeWithText(let v):
            try c.encode(TypeValue.badgeWithText, forKey: .type)
            try v.encode(to: encoder)
        }
    }
}
