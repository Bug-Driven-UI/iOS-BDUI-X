//
//  View+TapIfNeeded.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func applyTapIfNeeded(component: BduiComponentUI,
                          onAction: @escaping (BduiActionUI) -> Void) -> some View
    {
        if let actions = component.base.interactions?.onClick, !actions.isEmpty {
            self.contentShape(Rectangle())
                .onTapGesture {
                    actions.forEach(onAction)
                }
        } else {
            self
        }
    }
}
