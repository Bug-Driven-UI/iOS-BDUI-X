//
//  BduiComponentView.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

struct BduiComponentView: View {
    let component: BduiComponentUI
    let onAction: (BduiActionUI) -> Void

    @State private var inputMirror: String = ""

    var body: some View {
        self.content()
            .bduiBase(self.component.base, onAction: self.onAction)
            .onAppear { self.fire(self.component.base.interactions?.onShow) }
    }

    @ViewBuilder
    private func content() -> some View {
        switch self.component {
        case .text(_, let text):
            Text(text.value)
                .font(.system(size: text.style.size,
                              weight: FontWeightMapper.map(text.style.weight)))
                .foregroundColor(Color(bdui: text.color))
                .apply(decoration: text.style.decoration)

        case .image(_, let url):
            BduiImage(url: url)

        case .button(let base, let text, let enabled):

            BduiButtonView(text: text,
                           enabled: enabled,
                           base: base)
            {
                self.fire(base.interactions?.onClick)
            }

        case .input(let base, let text, let placeholder, let hint):
            BduiInputView(
                component: self.component,
                base: base,
                textModel: text,
                placeholder: placeholder,
                hint: hint
            ) { newValue in
                self.inputMirror = newValue
            }

        case .spacer:
            Spacer(minLength: 0)

        case .column:
            BduiContainerView(component: self.component, onAction: self.onAction)

        case .row:
            BduiContainerView(component: self.component, onAction: self.onAction)

        case .box:
            BduiContainerView(component: self.component, onAction: self.onAction)
        }
    }

    private func fire(_ actions: [BduiActionUI]?) {
        actions?.forEach(self.onAction)
    }
}

private extension Text {
    @ViewBuilder
    func applyTextDecoration(_ decoration: BduiTextDecorationType) -> some View {
        switch decoration {
        case .underline: self.underline()
        case .strikethrough: self.strikethrough()
        case .strikethroughRed: self.strikethrough(true, color: .red)
        case .italic: self.italic()
        case .regular: self
        }
    }
}
