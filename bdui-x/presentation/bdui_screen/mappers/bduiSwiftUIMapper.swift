//
//  bduiMappers.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

// MARK: - Color mapping

public extension BduiColorModel {
    func toSwiftUIColor(fallback: BduiColorModel = BduiColorModel(hex: "#FFFFFF")) -> Color {
        Color(hexString: hex) ?? Color(hexString: fallback.hex) ?? .white
    }
}

public extension Color {
    // Supports "#RRGGBB", "RRGGBB", "#AARRGGBB", "AARRGGBB"
    init?(hexString: String) {
        let s = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        guard s.count == 6 || s.count == 8, let v = UInt32(s, radix: 16) else { return nil }

        if s.count == 8 {
            let a = Double((v >> 24) & 0xFF) / 255.0
            let r = Double((v >> 16) & 0xFF) / 255.0
            let g = Double((v >> 8) & 0xFF) / 255.0
            let b = Double(v & 0xFF) / 255.0
            self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
        } else {
            let r = Double((v >> 16) & 0xFF) / 255.0
            let g = Double((v >> 8) & 0xFF) / 255.0
            let b = Double(v & 0xFF) / 255.0
            self = Color(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
        }
    }
}

// MARK: - Font weight mapping

public func toSwiftUIFontWeight(_ weight: Int) -> Font.Weight {
    switch weight {
    case 0...250: return .ultraLight   // ExtraLight
    case 251...350: return .light
    case 351...450: return .regular
    case 451...550: return .medium
    case 551...650: return .semibold
    case 651...750: return .bold
    case 751...1000: return .heavy     // ExtraBold -> heavy is the closest in SwiftUI
    default: return .regular
    }
}

// MARK: - Text style mapping

public func toSwiftUIFont(_ style: BduiTextStyleModel) -> Font {
    .system(size: CGFloat(style.size), weight: toSwiftUIFontWeight(style.weight), design: .default)
}

public struct BduiTextDecorations {
    public let italic: Bool
    public let underline: Bool
    public let strikethrough: Bool
    public let strikethroughColor: Color?
}

public func toSwiftUITextDecorations(_ style: BduiTextStyleModel) -> BduiTextDecorations {
    switch style.decorationType {
    case .italic:
        return .init(italic: true, underline: false, strikethrough: false, strikethroughColor: nil)
    case .underline:
        return .init(italic: false, underline: true, strikethrough: false, strikethroughColor: nil)
    case .strikethrough:
        return .init(italic: false, underline: false, strikethrough: true, strikethroughColor: nil)
    case .strikethroughRed:
        return .init(italic: false, underline: false, strikethrough: true, strikethroughColor: .red)
    case .regular:
        return .init(italic: false, underline: false, strikethrough: false, strikethroughColor: nil)
    }
}

// MARK: - Alignments and arrangements

public extension Optional where Wrapped == BduiHorizontalAlignmentModel {
    func toSwiftUI() -> HorizontalAlignment {
        switch self {
        case .some(.start): return .leading
        case .some(.center): return .center
        case .some(.end): return .trailing
        case .none: return .leading
        }
    }
}

public extension Optional where Wrapped == BduiVerticalAlignmentModel {
    func toSwiftUI() -> VerticalAlignment {
        switch self {
        case .some(.top): return .top
        case .some(.center): return .center
        case .some(.bottom): return .bottom
        case .none: return .top
        }
    }
}

public extension Optional where Wrapped == BduiHorizontalAndVerticalAlignmentModel {
    func toSwiftUI() -> Alignment {
        switch self {
        case .some(.topStart): return .topLeading
        case .some(.topCenter): return .top
        case .some(.topEnd): return .topTrailing
        case .some(.centerStart): return .leading
        case .some(.center): return .center
        case .some(.centerEnd): return .trailing
        case .some(.bottomStart): return .bottomLeading
        case .some(.bottomCenter): return .bottom
        case .some(.bottomEnd): return .bottomTrailing
        case .none: return .topLeading
        }
    }
}

public extension Optional where Wrapped == BduiTextAlignmentModel {
    func toSwiftUI() -> TextAlignment {
        switch self {
        case .some(.start): return .leading
        case .some(.center): return .center
        case .some(.end): return .trailing
        case .none: return .leading
        }
    }
}

// SwiftUI has no direct Arrangement equivalents for SpaceBetween/Around/Evenly.
// Provide a token so renderers can implement distribution with Spacers.
public enum BduiStackDistributionModel: Equatable {
    case start, center, end, spaceBetween, spaceEvenly, spaceAround
}

public extension Optional where Wrapped == BduiHorizontalArrangementModel {
    func toDistribution() -> BduiStackDistributionModel {
        switch self {
        case .some(.center): return .center
        case .some(.end): return .end
        case .some(.spaceAround): return .spaceAround
        case .some(.spaceBetween): return .spaceBetween
        case .some(.spaceEvenly): return .spaceEvenly
        case .some(.start), .none: return .start
        }
    }
}

public extension Optional where Wrapped == BduiVerticalArrangementModel {
    func toDistribution() -> BduiStackDistributionModel {
        switch self {
        case .some(.bottom): return .end
        case .some(.center): return .center
        case .some(.spaceAround): return .spaceAround
        case .some(.spaceBetween): return .spaceBetween
        case .some(.spaceEvenly): return .spaceEvenly
        case .some(.top), .none: return .start
        }
    }
}
