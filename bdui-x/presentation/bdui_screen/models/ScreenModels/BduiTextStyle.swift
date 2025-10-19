//
//  BduiTextStyle.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import Foundation

public struct BduiTextStyleModel: Equatable, Codable {
    public let decorationType: BduiTextDecorationTypeModel
    public let weight: Int
    public let size: Int
    public init(decorationType: BduiTextDecorationTypeModel, weight: Int, size: Int) {
        self.decorationType = decorationType
        self.weight = weight
        self.size = size
    }
}
