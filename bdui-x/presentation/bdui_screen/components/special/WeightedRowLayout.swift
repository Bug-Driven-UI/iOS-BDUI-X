//
//  WeightedRowLayout.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import SwiftUI

@available(iOS 16.0, *)
public struct WeightedRowLayout: Layout {
    public var spacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxW = proposal.width ?? 0
        var fixedTotal: CGFloat = 0
        var wrapWidths: [Int: CGFloat] = [:]
        var weightedIndices: [(idx: Int, weight: CGFloat)] = []
        var matchParentIndices: [Int] = []

        for (i, sv) in subviews.enumerated() {
            let widthRule = sv[BduiWidthRuleKey.self]
            switch widthRule {
            case .fixed(let w):
                fixedTotal += w
            case .wrap:
                let size = sv.sizeThatFits(.unspecified)
                wrapWidths[i] = size.width
                fixedTotal += size.width
            case .weighted(let f):
                weightedIndices.append((i, max(0, f)))
            case .matchParent:
                matchParentIndices.append(i)
            }
        }

        let flexibleCount = weightedIndices.count + matchParentIndices.count
        let totalSpacing = spacing * max(0, CGFloat(subviews.count - 1))
        let remaining = max(0, maxW - fixedTotal - totalSpacing)

        // Assign widths
        var assignedWidths: [Int: CGFloat] = [:]
        for (i, w) in wrapWidths {
            assignedWidths[i] = w
        }
        // Treat matchParent as weight 1
        let weightSum = weightedIndices.reduce(0) { $0 + $1.weight } + CGFloat(matchParentIndices.count)
        if weightSum > 0 {
            for (i, w) in weightedIndices {
                assignedWidths[i] = remaining * (w / weightSum)
            }
            for i in matchParentIndices {
                assignedWidths[i] = remaining * (1.0 / weightSum)
            }
        } else {
            // No flexible items; widths already assigned for fixed/wrap, others become zero width
            for (i, sv) in subviews.enumerated() where assignedWidths[i] == nil {
                let rule = sv[BduiWidthRuleKey.self]
                switch rule {
                case .fixed(let w): assignedWidths[i] = w
                case .wrap:
                    assignedWidths[i] = wrapWidths[i] ?? 0
                default:
                    assignedWidths[i] = 0
                }
            }
        }

        // Compute heights by measuring with assigned width
        var maxH: CGFloat = 0
        for (i, sv) in subviews.enumerated() {
            let w = assignedWidths[i] ?? 0
            let hRule = sv[BduiHeightRuleKey.self]
            let height: CGFloat
            switch hRule {
            case .fixed(let v): height = v
            default:
                let size = sv.sizeThatFits(.init(width: w, height: nil))
                height = size.height
            }
            maxH = max(maxH, height)
        }
        return CGSize(width: maxW, height: maxH)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxW = bounds.width
        let totalSpacing = spacing * max(0, CGFloat(subviews.count - 1))

        // Recompute identical to sizeThatFits to place
        var fixedTotal: CGFloat = 0
        var wrapWidths: [Int: CGFloat] = [:]
        var weightedIndices: [(idx: Int, weight: CGFloat)] = []
        var matchParentIndices: [Int] = []

        for (i, sv) in subviews.enumerated() {
            let widthRule = sv[BduiWidthRuleKey.self]
            switch widthRule {
            case .fixed(let w):
                fixedTotal += w
            case .wrap:
                let size = sv.sizeThatFits(.unspecified)
                wrapWidths[i] = size.width
                fixedTotal += size.width
            case .weighted(let f):
                weightedIndices.append((i, max(0, f)))
            case .matchParent:
                matchParentIndices.append(i)
            }
        }

        let remaining = max(0, maxW - fixedTotal - totalSpacing)
        var assignedWidths: [Int: CGFloat] = [:]
        for (i, w) in wrapWidths {
            assignedWidths[i] = w
        }
        let weightSum = weightedIndices.reduce(0) { $0 + $1.weight } + CGFloat(matchParentIndices.count)
        if weightSum > 0 {
            for (i, w) in weightedIndices {
                assignedWidths[i] = remaining * (w / weightSum)
            }
            for i in matchParentIndices {
                assignedWidths[i] = remaining * (1.0 / weightSum)
            }
        } else {
            for (i, sv) in subviews.enumerated() where assignedWidths[i] == nil {
                let rule = sv[BduiWidthRuleKey.self]
                switch rule {
                case .fixed(let w): assignedWidths[i] = w
                case .wrap:
                    assignedWidths[i] = wrapWidths[i] ?? 0
                default:
                    assignedWidths[i] = 0
                }
            }
        }

        // Place left-to-right, vertically centered
        var x = bounds.minX
        for (i, sv) in subviews.enumerated() {
            let w = assignedWidths[i] ?? 0
            let size = sv.sizeThatFits(.init(width: w, height: nil))
            let hRule = sv[BduiHeightRuleKey.self]
            let actualH: CGFloat = {
                switch hRule {
                case .fixed(let v): return v
                default: return size.height
                }
            }()
            let y = bounds.midY - actualH / 2
            sv.place(at: CGPoint(x: x, y: y), proposal: .init(width: w, height: actualH))
            x += w + spacing
        }
    }
}
