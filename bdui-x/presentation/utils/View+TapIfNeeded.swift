//
//  View+TapIfNeeded.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

private struct TapIfNeededModifier: ViewModifier {
    let component: BduiComponentUI
    let onAction: (BduiActionUI) -> Void

    func body(content: Content) -> some View {
        guard let actions = component.base.interactions?.onClick, !actions.isEmpty else {
            return AnyView(content)
        }
        return AnyView(
            content
                .contentShape(Rectangle())
                .onTapGesture { actions.forEach(onAction) }
        )
    }
}

public extension View {
    func applyTapIfNeeded(component: BduiComponentUI,
                          onAction: @escaping (BduiActionUI) -> Void) -> some View
    {
        modifier(TapIfNeededModifier(component: component, onAction: onAction))
    }
}
