//
//  View+RoundedStroke.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func bduiBackground(base: BduiComponentBaseProperties) -> some View {
        let bg = base.backgroundColor.map(Color.init(bdui:))
        let shape = base.shape
        let cornerRadius = shape.map { max($0.topStart, $0.topEnd) } ?? 0
        let border = base.border
        background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(bg ?? Color.clear)
        )
        .overlay(
            Group {
                if let border {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color(bdui: border.color), lineWidth: border.thickness)
                }
            }
        )
        .padding(base.margins?.edgeInsets ?? EdgeInsets())
        .padding(.zero)
    }

    @ViewBuilder
    func bduiSize(width: BduiComponentSize, height: BduiComponentSize) -> some View {
        frame(
            width: {
                if case .fixed(let v) = width { return v }
                return nil
            }(),
            height: {
                if case .fixed(let v) = height { return v }
                return nil
            }()
        )
        .modifier(WeightedModifier(width: width, height: height))
    }
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
