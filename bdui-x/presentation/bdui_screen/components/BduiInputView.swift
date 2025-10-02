//
//  BduiInputView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

struct BduiInputView: View {
    let component: BduiComponentUI
    let base: BduiComponentBaseProperties
    let textModel: BduiText
    let placeholder: BduiText?
    let hint: BduiText?
    let onChange: (String) -> Void

    @State private var internalText: String = ""
    @State private var externalSnapshot: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                if internalText.isEmpty, let placeholder {
                    Text(placeholder.value)
                        .font(.system(size: placeholder.style.size,
                                      weight: FontWeightMapper.map(placeholder.style.weight)))
                        .foregroundColor(Color(bdui: placeholder.color).opacity(0.5))
                }
                TextField("", text: $internalText.onChange { newValue in
                    onChange(newValue)
                })
                .textFieldStyle(.plain)
                .font(.system(size: textModel.style.size,
                              weight: FontWeightMapper.map(textModel.style.weight)))
                .foregroundColor(Color(bdui: textModel.color))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(bdui: base.backgroundColor ?? .init(hex: PresentationConstants.DEFAULT_BG_COLOR_HEX)))
            )

            if let hint, !hint.value.isEmpty {
                Text(hint.value)
                    .font(.system(size: hint.style.size,
                                  weight: FontWeightMapper.map(hint.style.weight)))
                    .foregroundColor(Color(bdui: hint.color))
                    .opacity(0.8)
            }
        }
        .onAppear {
            internalText = textModel.value
            externalSnapshot = textModel.value
        }
        .onChange(of: textModel.value) { newExternal in
            if newExternal != externalSnapshot && newExternal != internalText {
                internalText = newExternal
            }
            externalSnapshot = newExternal
        }
    }
}

private extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
