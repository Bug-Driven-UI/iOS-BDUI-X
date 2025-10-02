//
//  BduiColor.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import SwiftUI

public struct BduiColor: Equatable, Hashable {
    public let hex: String
    public static let `default` = BduiColor(hex: "#FFFFFFFF")
    public init(hex: String) { self.hex = hex }
}

public extension Color {
    init(bdui: BduiColor) {
        let cleaned = bdui.hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleaned.count {
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        case 6:
            (a, r, g, b) = (255,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(.sRGB,
                  red: Double(r)/255,
                  green: Double(g)/255,
                  blue: Double(b)/255,
                  opacity: Double(a)/255)
    }
}

@available(iOS 15.0, *)
extension BduiColor: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color(bdui: self)
    }
}
