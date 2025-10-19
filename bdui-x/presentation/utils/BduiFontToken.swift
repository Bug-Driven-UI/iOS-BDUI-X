//
//  BduiFontToken.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import SwiftUI

// Token-based typography. Keeps your Android names: H20_H2, M10_P, M20_P
public enum BduiFontToken: CaseIterable, Hashable {
    case H20_H2 // 26 / 30, ExtraBold
    case M10_P // 15 / 22, Medium
    case M20_P // 15 / 20, Medium
}

// A small text style container to carry font and lineHeight metadata
public struct ThemeTextStyle: Equatable {
    public let font: Font
    public let lineHeight: CGFloat

    public init(font: Font, lineHeight: CGFloat) {
        self.font = font
        self.lineHeight = lineHeight
    }
}

public struct BduiTypography: Equatable {
    public let H20_H2: ThemeTextStyle
    public let M10_P: ThemeTextStyle
    public let M20_P: ThemeTextStyle

    public init(
        H20_H2: ThemeTextStyle,
        M10_P: ThemeTextStyle,
        M20_P: ThemeTextStyle
    ) {
        self.H20_H2 = H20_H2
        self.M10_P = M10_P
        self.M20_P = M20_P
    }

    public func style(_ token: BduiFontToken) -> ThemeTextStyle {
        switch token {
        case .H20_H2: return H20_H2
        case .M10_P: return M10_P
        case .M20_P: return M20_P
        }
    }

    public static let manropeDefault = BduiTypography(
        H20_H2: ThemeTextStyle(
            font: Font.custom("Manrope-ExtraBold", size: 26),
            lineHeight: 30
        ),
        M10_P: ThemeTextStyle(
            font: Font.custom("Manrope-Medium", size: 15),
            lineHeight: 22
        ),
        M20_P: ThemeTextStyle(
            font: Font.custom("Manrope-Medium", size: 15),
            lineHeight: 20
        )
    )
}

private struct BduiTypographyKey: EnvironmentKey {
    static let defaultValue: BduiTypography = .manropeDefault
}

public extension EnvironmentValues {
    var bduiTypography: BduiTypography {
        get { self[BduiTypographyKey.self] }
        set { self[BduiTypographyKey.self] = newValue }
    }
}

public extension View {
    func bduiTextStyle(_ style: ThemeTextStyle) -> some View {
        font(style.font)
            .lineSpacing(max(style.lineHeight - style.font.size, 0))
    }
}

private extension Font {
    var size: CGFloat {
        0
    }
}
