//
//  BduiColor.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import SwiftUI

public struct BduiColorModel: Equatable, Codable {
    public let hex: String
    public init(hex: String) { self.hex = hex }
}

public extension BduiColorModel {
    func toColor() -> Color {
        let s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&value) else { return Color(.clear) }

        switch s.count {
        case 6:
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            return  Color(red: r, green: g, blue: b)
        case 8:
            let a = Double((value >> 24) & 0xFF) / 255.0
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            return Color(red: r, green: g, blue: b).opacity(a)
        default:
            return Color(.white)
        }
    }
}
