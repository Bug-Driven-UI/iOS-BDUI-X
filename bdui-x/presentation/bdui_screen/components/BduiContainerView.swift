//
//  BduiContainerView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

struct BduiContainerView: View {
    let component: BduiComponentUI
    let onAction: (BduiActionUI) -> Void

    var body: some View {
        switch component {
        case .column(let base, let children):
            containerBody(base: base, axis: .vertical, children: children)

        case .row(let base, let children):
            containerBody(base: base, axis: .horizontal, children: children)

        case .box(let base, let children):
            ZStack {
                ForEachIndexed(children) { child in
                    BduiComponentView(component: child, onAction: onAction)
                }
            }
            .bduiBase(base, onAction: onAction)

        default:
            // Fallback for non-container types
            BduiComponentView(component: component, onAction: onAction)
        }
    }

    @ViewBuilder
    private func containerBody(base: BduiComponentBaseProperties,
                               axis: Axis,
                               children: [BduiComponentUI]) -> some View
    {
        if #available(iOS 16.0, *) {
            if axis == .vertical {
                WeightedVStack(alignment: .leading, spacing: 0) {
                    ForEachIndexed(children) { child in
                        weightedChildView(child, axis: axis)
                    }
                }
                .bduiBase(base, onAction: onAction)
            } else {
                WeightedHStack(alignment: .center, spacing: 0) {
                    ForEachIndexed(children) { child in
                        weightedChildView(child, axis: axis)
                    }
                }
                .bduiBase(base, onAction: onAction)
            }
        } else {
            
            if axis == .vertical {
                VStack(alignment: .leading, spacing: 0) {
                    ForEachIndexed(children) { child in
                        BduiComponentView(component: child, onAction: onAction)
                    }
                }
                .bduiBase(base, onAction: onAction)
            } else {
                HStack(alignment: .center, spacing: 0) {
                    ForEachIndexed(children) { child in
                        BduiComponentView(component: child, onAction: onAction)
                    }
                }
                .bduiBase(base, onAction: onAction)
            }
        }
    }

    @ViewBuilder
    private func weightedChildView(_ child: BduiComponentUI,
                                   axis: Axis) -> some View
    {
        
        let weight: CGFloat? = {
            switch axis {
            case .vertical:
                if case .weighted(let f) = child.base.height { return f }
            case .horizontal:
                if case .weighted(let f) = child.base.width { return f }
            }
            return nil
        }()

        BduiComponentView(component: child, onAction: onAction)
            .modifier(WeightApplyModifier(weight: weight))
    }

    private struct WeightApplyModifier: ViewModifier {
        let weight: CGFloat?
        func body(content: Content) -> some View {
            if let w = weight, w > 0 {
                content.weight(w)
            } else {
                content
            }
        }
    }
}
