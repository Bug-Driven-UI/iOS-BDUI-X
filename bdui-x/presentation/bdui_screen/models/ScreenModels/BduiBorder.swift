//
//  BduiBorder.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import Foundation

public struct BduiBorderModel: Equatable, Codable {
    public let color: BduiColorModel
    public let thickness: Int
    public init(color: BduiColorModel, thickness: Int) {
        self.color = color
        self.thickness = thickness
    }
}
