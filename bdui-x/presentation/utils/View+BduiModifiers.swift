//
//  View+RoundedStroke.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

extension View {
    func bduiBase(_ base: BduiComponentBaseProperties,
                  onAction: ((BduiActionUI) -> Void)? = nil) -> some View
    {
        self
            // 1. Margins (outside spacing)
            .applyMargins(base.margins)
            // 2. Size resolution
            .bduiSize(width: base.width, height: base.height)
            // 3-5. Visual styling
            .styled(background: base.backgroundColor, border: base.border, shape: base.shape)
            // 6. Interactions
            .applyInteractions(base.interactions, onAction: onAction)
            // 7. Inner paddings
            .applyPaddings(base.paddings)
    }

    // MARK: - Size Handling

    @ViewBuilder
    func bduiSize(width: BduiComponentSize,
                  height: BduiComponentSize) -> some View
    {
        let priority = max(width.weightValue, height.weightValue)
        self
            .applyWidth(width)
            .applyHeight(height)
            .layoutPriority(priority)
    }

    @ViewBuilder
    func applyWidth(_ size: BduiComponentSize) -> some View {
        switch size {
        case .fixed(let w):
            self.frame(width: w, alignment: .leading)
        case .matchParent:
            self.frame(maxWidth: .infinity, alignment: .leading)
        case .weighted:
            // Expand and rely on layoutPriority
            self.frame(maxWidth: .infinity, alignment: .leading)
        case .wrapContent:
            self
        }
    }

    @ViewBuilder
    func applyHeight(_ size: BduiComponentSize) -> some View {
        switch size {
        case .fixed(let h):
            self.frame(height: h, alignment: .top)
        case .matchParent:
            self.frame(maxHeight: .infinity, alignment: .top)
        case .weighted:
            self.frame(maxHeight: .infinity, alignment: .top)
        case .wrapContent:
            self
        }
    }

    @ViewBuilder
    func bduiSized(width: BduiComponentSize,
                   height: BduiComponentSize) -> some View
    {
        let weight = max(width.weightValue, height.weightValue)
        self
            .applyWidth(width)
            .applyHeight(height)
            .layoutPriority(Double(weight))
    }

    @ViewBuilder
    func applyMargins(_ insets: BduiComponentInsetsUI?) -> some View {
        if let i = insets {
            self.padding(i.edgeInsets)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyPaddings(_ insets: BduiComponentInsetsUI?) -> some View {
        if let i = insets {
            self.padding(i.edgeInsets)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyInteractions(_ interactions: BduiComponentInteractionsUI?,
                           onAction: ((BduiActionUI) -> Void)?) -> some View
    {
        if
            let interactions,
            let clickActions = interactions.onClick,
            !clickActions.isEmpty,
            let onAction
        {
            self
                .contentShape(Rectangle())
                .onTapGesture {
                    clickActions.forEach(onAction)
                }
        } else {
            self
        }
    }

    // Background + Border + Shape (clip before background to mimic Compose)
    @ViewBuilder
    func styled(background: BduiColor?,
                border: BduiBorder?,
                shape: BduiShape.RoundedCorners?) -> some View
    {
        if let shape = shape {
            let s = RoundedCornersShape(shape)
            self
                .clipShape(s)
                .background(
                    Group {
                        if let bg = background {
                            Color(bdui: bg)
                        } else {
                            Color.clear
                        }
                    }
                )
                .overlay {
                    if let border {
                        s.stroke(Color(bdui: border.color),
                                 lineWidth: border.thickness)
                    }
                }
        } else {
            self
                .background(
                    Group {
                        if let bg = background {
                            Color(bdui: bg)
                        } else {
                            Color.clear
                        }
                    }
                )
                .overlay {
                    if let border {
                        Rectangle()
                            .stroke(Color(bdui: border.color),
                                    lineWidth: border.thickness)
                    }
                }
        }
    }
}

private extension BduiComponentSize {
    var weightValue: CGFloat {
        if case .weighted(let v) = self { return v }
        return 0
    }
}

// Simple type-erased Shape wrapper (for convenience)
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    init<S: Shape>(_ shape: S) { self._path = { rect in shape.path(in: rect) } }
    func path(in rect: CGRect) -> Path { self._path(rect) }
}

private struct WeightedModifier: ViewModifier {
    let width: BduiComponentSize
    let height: BduiComponentSize
    func body(content: Content) -> some View {
        var lp: Double = 0
        if case .weighted(let f) = width { lp = max(lp, Double(f)) }
        if case .weighted(let f) = height { lp = max(lp, Double(f)) }
        return content.layoutPriority(lp)
    }
}
