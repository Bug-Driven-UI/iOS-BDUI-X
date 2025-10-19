//
//  BduiThemeAccess.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//
import SwiftUI


@ViewBuilder
public func BduiTheme(
    colors: BduiColorPalette = .default,
    typography: BduiTypography = .manropeDefault,
    @ViewBuilder content: () -> some View
) -> some View {
    content()
        .environment(\.bduiColors, colors)
        .environment(\.bduiTypography, typography)
}


public enum BduiThemeAccess {}

public extension BduiThemeAccess {
    struct Reader<Content: View>: View {
        @Environment(\.bduiColors) private var colors
        @Environment(\.bduiTypography) private var typography

        private let content: (_ colors: BduiColorPalette, _ typography: BduiTypography) -> Content

        public init(@ViewBuilder content: @escaping (_ colors: BduiColorPalette, _ typography: BduiTypography) -> Content) {
            self.content = content
        }

        public var body: some View {
            content(colors, typography)
        }
    }
}
