//
//  BduiButtonView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

struct BduiButtonView: View {
    let text: BduiText
    let enabled: Bool
    let base: BduiComponentBaseProperties
    let onTap: () -> Void

    var body: some View {
        Button {
            if enabled { onTap() }
        } label: {
            Text(text.value)
                .font(.system(size: text.style.size,
                              weight: FontWeightMapper.map(text.style.weight)))
                .foregroundColor(Color(bdui: text.color).opacity(enabled ? 1 : 0.4))
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: {
                    if case .matchParent = base.width { return .infinity }
                    return nil
                }(), alignment: .center)
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
    }
}
