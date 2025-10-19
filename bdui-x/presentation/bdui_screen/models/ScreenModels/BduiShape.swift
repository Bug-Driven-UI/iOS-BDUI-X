//
//  BduiShape.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import Foundation

public enum BduiShapeModel: Equatable, Codable {
    case roundedCorners(RoundedCornersModel)

    public struct RoundedCornersModel: Equatable, Codable {
        public let topStart: Int
        public let topEnd: Int
        public let bottomStart: Int
        public let bottomEnd: Int
        public init(topStart: Int, topEnd: Int, bottomStart: Int, bottomEnd: Int) {
            self.topStart = topStart
            self.topEnd = topEnd
            self.bottomStart = bottomStart
            self.bottomEnd = bottomEnd
        }
    }

    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable { case roundedCorners }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .roundedCorners:
            self = try .roundedCorners(RoundedCornersModel(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .roundedCorners(let v): try v.encode(to: encoder)
        }
    }
}
