//
//  WeightedColumnLayout.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import SwiftUI

@available(iOS 16.0, *)
public struct WeightedColumnLayout: Layout {
    public var spacing: CGFloat

    public init(spacing: CGFloat = 8) { self.spacing = spacing }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxH = proposal.height ?? 0
        var fixedTotal: CGFloat = 0
        var wrapHeights: [Int: CGFloat] = [:]
        var weightedIndices: [(idx: Int, weight: CGFloat)] = []
        var matchParentIndices: [Int] = []

        var maxW: CGFloat = 0

        for (i, sv) in subviews.enumerated() {
            let hRule = sv[BduiHeightRuleKey.self]
            switch hRule {
            case .fixed(let h):
                fixedTotal += h
            case .wrap:
                let size = sv.sizeThatFits(.unspecified)
                wrapHeights[i] = size.height
                fixedTotal += size.height
                maxW = max(maxW, size.width)
            case .weighted(let f):
                weightedIndices.append((i, max(0, f)))
            case .matchParent:
                matchParentIndices.append(i)
            }
            // Also track max width for fixed/wrap
            if case .fixed = hRule {
                let size = sv.sizeThatFits(.unspecified)
                maxW = max(maxW, size.width)
            }
        }

        let totalSpacing = spacing * max(0, CGFloat(subviews.count - 1))
        let remaining = max(0, maxH - fixedTotal - totalSpacing)

        // Heights assigned; width is max of measured widths
        if remaining > 0 {
            // No need to compute exact heights here for total size; width is already captured
        }
        return CGSize(width: proposal.width ?? maxW, height: maxH)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxH = bounds.height
        let totalSpacing = spacing * max(0, CGFloat(subviews.count - 1))

        var fixedTotal: CGFloat = 0
        var wrapHeights: [Int: CGFloat] = [:]
        var weightedIndices: [(idx: Int, weight: CGFloat)] = []
        var matchParentIndices: [Int] = []
        var measuredWidths: [Int: CGFloat] = [:]

        for (i, sv) in subviews.enumerated() {
            let hRule = sv[BduiHeightRuleKey.self]
            switch hRule {
            case .fixed(let h):
                fixedTotal += h
                let size = sv.sizeThatFits(.unspecified)
                measuredWidths[i] = size.width
            case .wrap:
                let size = sv.sizeThatFits(.unspecified)
                wrapHeights[i] = size.height
                fixedTotal += size.height
                measuredWidths[i] = size.width
            case .weighted(let f):
                weightedIndices.append((i, max(0, f)))
            case .matchParent:
                matchParentIndices.append(i)
            }
        }

        let remaining = max(0, maxH - fixedTotal - totalSpacing)
        var assignedHeights: [Int: CGFloat] = [:]
        for (i, h) in wrapHeights {
            assignedHeights[i] = h
        }
        let weightSum = weightedIndices.reduce(0) { $0 + $1.weight } + CGFloat(matchParentIndices.count)
        if weightSum > 0 {
            for (i, w) in weightedIndices {
                assignedHeights[i] = remaining * (w / weightSum)
            }
            for i in matchParentIndices {
                assignedHeights[i] = remaining * (1.0 / weightSum)
            }
        } else {
            for (i, sv) in subviews.enumerated() where assignedHeights[i] == nil {
                let rule = sv[BduiHeightRuleKey.self]
                switch rule {
                case .fixed(let h): assignedHeights[i] = h
                case .wrap:
                    assignedHeights[i] = wrapHeights[i] ?? 0
                default:
                    assignedHeights[i] = 0
                }
            }
        }

        var y = bounds.minY
        for (i, sv) in subviews.enumerated() {
            let h = assignedHeights[i] ?? 0
            let wRule = sv[BduiWidthRuleKey.self]
            let widthProposal: ProposedViewSize
            switch wRule {
            case .fixed(let w): widthProposal = .init(width: w, height: h)
            case .matchParent, .weighted:
                widthProposal = .init(width: bounds.width, height: h)
            case .wrap:
                widthProposal = .init(width: nil, height: h)
            }
            let size = sv.sizeThatFits(widthProposal)
            let w: CGFloat = {
                switch wRule {
                case .fixed(let w): return w
                case .matchParent, .weighted: return bounds.width
                case .wrap: return size.width
                }
            }()
            sv.place(
                at: CGPoint(x: bounds.minX, y: y),
                proposal: .init(width: w, height: h)
            )
            y += h + spacing
        }
    }
}
