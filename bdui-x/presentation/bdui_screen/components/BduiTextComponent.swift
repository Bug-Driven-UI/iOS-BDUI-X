//
//  BduiTextComponent.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import SwiftUI

public struct BduiTextComponent: View {
    let component: BduiTextComponentModel

    public init(component: BduiTextComponentModel) {
        self.component = component
    }

    public var body: some View {
        let s = component.text.style
        let fgColor = component.text.color.toColor()
        let text = component.text.value.asDisplayString

        // Build NSAttributedString with iOS 13-safe attributes for decoration/italic
        let ns = makeAttributedString(
            text: text,
            style: s,
            strikeIsRed: s.decorationType == .strikethroughRed
        )

        // Apply foreground color and alignment via SwiftUI (safe on iOS 13+)
        return AnyView(
            Text(AttributedString(ns))
                .foregroundColor(fgColor)
                .multilineTextAlignment(component.text.textAlignment.toSwiftUI())
                .fixedSize(horizontal: false, vertical: true)
        )
    }
}

// MARK: - NSAttributedString builder (iOS 13+)

private func makeAttributedString(
    text: String,
    style: BduiTextStyleModel,
    strikeIsRed: Bool
) -> NSAttributedString {
    let attr = NSMutableAttributedString(string: text)

    // Font: weight + optional italic trait
    let uiWeight = mapUIFontWeight(style.weight)
    let baseUIFont = UIFont.systemFont(ofSize: CGFloat(style.size), weight: uiWeight)
    let fontDesc: UIFontDescriptor
    if style.decorationType == .italic {
        fontDesc = baseUIFont.fontDescriptor.withSymbolicTraits([.traitItalic]) ?? baseUIFont.fontDescriptor
    } else {
        fontDesc = baseUIFont.fontDescriptor
    }
    let font = UIFont(descriptor: fontDesc, size: baseUIFont.pointSize)

    var attributes: [NSAttributedString.Key: Any] = [
        .font: font
    ]

    switch style.decorationType {
    case .underline:
        attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue

    case .strikethrough, .strikethroughRed:
        attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        if strikeIsRed {
            attributes[.strikethroughColor] = UIColor(red: 1.0, green: 0.25, blue: 0.325, alpha: 1.0)
        }

    case .italic, .regular:
        break
    }

    attr.addAttributes(attributes, range: NSRange(location: 0, length: attr.length))
    return attr
}

// MARK: - Helpers

private extension Optional where Wrapped == BduiTextAlignmentModel {
    func toSwiftUI() -> TextAlignment {
        switch self {
        case .some(.start): return .leading
        case .some(.center): return .center
        case .some(.end): return .trailing
        case .none: return .leading
        }
    }
}

private extension TextOrLocalStateModel {
    var asDisplayString: String {
        switch self {
        case .text(let v): return v
        case .localState(let path): return "#{\(path)}"
        }
    }
}

private func mapUIFontWeight(_ w: Int) -> UIFont.Weight {
    switch w {
    case ..<200: return .ultraLight
    case 200..<300: return .thin
    case 300..<400: return .light
    case 400..<500: return .regular
    case 500..<600: return .medium
    case 600..<700: return .semibold
    case 700..<800: return .bold
    case 800..<900: return .heavy
    default: return .black
    }
}
