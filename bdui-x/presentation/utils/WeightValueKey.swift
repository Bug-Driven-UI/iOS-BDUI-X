//
//  WeightValueKey.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

@available(iOS 16.0, *)
private struct WeightValueKey: LayoutValueKey {
    static let defaultValue: CGFloat = 0
}

// MARK: - Public Weight Modifiers

public extension View {
    @ViewBuilder
    func weight(_ value: CGFloat) -> some View {
        if #available(iOS 16.0, *) {
            self.layoutValue(key: WeightValueKey.self, value: max(0, value))
        } else {
            layoutPriority(Double(max(0, value)))
        }
    }

    
    @ViewBuilder
    func weight(_ value: CGFloat, axis: Axis) -> some View {
        if #available(iOS 16.0, *) {
            self.layoutValue(key: WeightValueKey.self, value: max(0, value))
        } else {
            
            switch axis {
            case .horizontal:
                self
                    
                    .layoutPriority(Double(max(0, value)))
            case .vertical:
                self
                    .layoutPriority(Double(max(0, value)))
            }
        }
    }
}

// MARK: - Weighted VStack (Vertical distribution) iOS 16+

@available(iOS 16.0, *)
struct WeightedVStack: Layout {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?

    init(alignment: HorizontalAlignment = .leading,
         spacing: CGFloat? = 0)
    {
        self.alignment = alignment
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize
    {
        let proposedWidth = proposal.width
        var totalFixedHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for sv in subviews where sv[WeightValueKey.self] == 0 {
            let size = sv.sizeThatFits(
                ProposedViewSize(width: proposedWidth, height: nil)
            )
            totalFixedHeight += size.height
            maxWidth = max(maxWidth, size.width)
        }

        let spacingTotal = spacingValue * CGFloat(max(subviews.count - 1, 0))
        totalFixedHeight += spacingTotal

        let finalHeight: CGFloat
        if let ph = proposal.height {
            finalHeight = ph
        } else {
            finalHeight = totalFixedHeight
        }

        if let proposedWidth {
            maxWidth = max(maxWidth, proposedWidth)
        }

        return CGSize(width: maxWidth, height: finalHeight)
    }

    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ())
    {
        var y = bounds.minY
        let totalAvailableHeight = bounds.height

        // Separate weighted / fixed
        var fixedHeights: CGFloat = 0
        var weighted: [(LayoutSubview, CGFloat)] = []
        for sv in subviews {
            let w = sv[WeightValueKey.self]
            if w > 0 {
                weighted.append((sv, w))
            } else {
                let size = sv.sizeThatFits(
                    ProposedViewSize(width: bounds.width, height: nil)
                )
                fixedHeights += size.height
            }
        }

        let spacingTotal = spacingValue * CGFloat(max(subviews.count - 1, 0))
        let remaining = max(0, totalAvailableHeight - fixedHeights - spacingTotal)
        let totalWeight = weighted.reduce(0) { $0 + $1.1 }

        for sv in subviews {
            let w = sv[WeightValueKey.self]
            let height: CGFloat
            if w > 0 && totalWeight > 0 {
                height = (w / totalWeight) * remaining
            } else {
                let size = sv.sizeThatFits(
                    ProposedViewSize(width: bounds.width, height: nil)
                )
                height = size.height
            }

            let proposed = ProposedViewSize(width: bounds.width, height: height)
            let measured = sv.sizeThatFits(proposed)

            let x: CGFloat
            switch alignment {
            case .leading: x = bounds.minX
            case .trailing: x = bounds.maxX - measured.width
            case .center: x = bounds.midX - measured.width / 2
            default: x = bounds.minX
            }

            sv.place(at: CGPoint(x: x, y: y),
                     proposal: ProposedViewSize(width: measured.width, height: height))
            y += height + spacingValue
        }
    }

    private var spacingValue: CGFloat { spacing ?? 0 }
}

// MARK: - Weighted HStack (Horizontal distribution) iOS 16+

@available(iOS 16.0, *)
struct WeightedHStack: Layout {
    let alignment: VerticalAlignment
    let spacing: CGFloat?

    init(alignment: VerticalAlignment = .center,
         spacing: CGFloat? = 0)
    {
        self.alignment = alignment
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize
    {
        let proposedHeight = proposal.height
        var totalFixedWidth: CGFloat = 0
        var maxHeight: CGFloat = 0

        for sv in subviews where sv[WeightValueKey.self] == 0 {
            let size = sv.sizeThatFits(
                ProposedViewSize(width: nil, height: proposedHeight)
            )
            totalFixedWidth += size.width
            maxHeight = max(maxHeight, size.height)
        }

        let spacingTotal = spacingValue * CGFloat(max(subviews.count - 1, 0))
        totalFixedWidth += spacingTotal

        let finalWidth: CGFloat
        if let pw = proposal.width {
            finalWidth = pw
        } else {
            finalWidth = totalFixedWidth
        }

        if let proposedHeight {
            maxHeight = max(maxHeight, proposedHeight)
        }

        return CGSize(width: finalWidth, height: maxHeight)
    }

    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ())
    {
        var x = bounds.minX
        let totalAvailableWidth = bounds.width

        var fixedWidths: CGFloat = 0
        var weighted: [(LayoutSubview, CGFloat)] = []
        for sv in subviews {
            let w = sv[WeightValueKey.self]
            if w > 0 {
                weighted.append((sv, w))
            } else {
                let size = sv.sizeThatFits(
                    ProposedViewSize(width: nil, height: bounds.height)
                )
                fixedWidths += size.width
            }
        }

        let spacingTotal = spacingValue * CGFloat(max(subviews.count - 1, 0))
        let remaining = max(0, totalAvailableWidth - fixedWidths - spacingTotal)
        let totalWeight = weighted.reduce(0) { $0 + $1.1 }

        for sv in subviews {
            let w = sv[WeightValueKey.self]
            let width: CGFloat
            if w > 0 && totalWeight > 0 {
                width = (w / totalWeight) * remaining
            } else {
                let size = sv.sizeThatFits(
                    ProposedViewSize(width: nil, height: bounds.height)
                )
                width = size.width
            }

            let proposed = ProposedViewSize(width: width, height: bounds.height)
            let measured = sv.sizeThatFits(proposed)

            let y: CGFloat
            switch alignment {
            case .top: y = bounds.minY
            case .bottom: y = bounds.maxY - measured.height
            case .center: y = bounds.midY - measured.height / 2
            default: y = bounds.minY
            }

            sv.place(at: CGPoint(x: x, y: y),
                     proposal: ProposedViewSize(width: width, height: measured.height))
            x += width + spacingValue
        }
    }

    private var spacingValue: CGFloat { spacing ?? 0 }
}
