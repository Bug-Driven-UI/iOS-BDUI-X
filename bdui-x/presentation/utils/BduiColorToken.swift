//
//  BduiColorToken.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import SwiftUI


public enum BduiColorToken: CaseIterable, Hashable {
    case textPrimary
    case textInversePrimary
    case buttonBgPrimary
    case buttonTextPrimary
    case toastDefault
    case dividerDefault
}

public struct BduiColorPalette: Equatable {
    public let textPrimary: Color
    public let textInversePrimary: Color
    public let buttonBgPrimary: Color
    public let buttonTextPrimary: Color
    public let toastDefault: Color
    public let dividerDefault: Color

    public init(
        textPrimary: Color,
        textInversePrimary: Color,
        buttonBgPrimary: Color,
        buttonTextPrimary: Color,
        toastDefault: Color,
        dividerDefault: Color
    ) {
        self.textPrimary = textPrimary
        self.textInversePrimary = textInversePrimary
        self.buttonBgPrimary = buttonBgPrimary
        self.buttonTextPrimary = buttonTextPrimary
        self.toastDefault = toastDefault
        self.dividerDefault = dividerDefault
    }

    public func color(_ token: BduiColorToken) -> Color {
        switch token {
        case .textPrimary: return textPrimary
        case .textInversePrimary: return textInversePrimary
        case .buttonBgPrimary: return buttonBgPrimary
        case .buttonTextPrimary: return buttonTextPrimary
        case .toastDefault: return toastDefault
        case .dividerDefault: return dividerDefault
        }
    }

    public static let `default` = BduiColorPalette(
        textPrimary: Color(hex: 0x000000),
        textInversePrimary: Color(hex: 0xFFFFFF),
        buttonBgPrimary: Color(hex: 0x141414),
        buttonTextPrimary: Color(hex: 0xFFFFFF),
        toastDefault: Color(hex: 0x141414),
        dividerDefault: Color(hex: 0xEBEAE8)
    )
}

private struct BduiColorsKey: EnvironmentKey {
    static let defaultValue: BduiColorPalette = .default
}
public extension EnvironmentValues {
    var bduiColors: BduiColorPalette {
        get { self[BduiColorsKey.self] }
        set { self[BduiColorsKey.self] = newValue }
    }
}

public extension BduiColorPalette {
    var text: (primary: Color, inversePrimary: Color) {
        (textPrimary, textInversePrimary)
    }
    var button: (bgPrimary: Color, textPrimary: Color) {
        (buttonBgPrimary, buttonTextPrimary)
    }
    var toast: Color { toastDefault }
    var divider: Color { dividerDefault }
}

public extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
