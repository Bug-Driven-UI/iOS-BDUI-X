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

    @State private var inputText = ""

    var body: some View {
        content()
            .bduiBackground(base: component.base)
            .bduiSize(width: component.base.width, height: component.base.height)
            .padding(component.base.paddings?.edgeInsets ?? EdgeInsets())
            .onAppear { fire(component.base.interactions?.onShow) }
            .applyTapIfNeeded(component: component, onAction: onAction)
    }

    @ViewBuilder
    private func content() -> some View {
        switch component {
        case .text(_, let text):
            Text(text.value)
                .font(.system(
                    size: text.style.size,
                    weight: FontWeightMapper.map(text.style.weight)
                ))
                .foregroundColor(Color(bdui: text.color))
                .apply(decoration: text.style.decoration)

        case .image(_, let url):
            BduiImage(url: url)

        case .button(_, let text, let enabled):
            Button {
                if enabled { fire(component.base.interactions?.onClick) }
            } label: {
                Text(text.value)
                    .font(.system(size: text.style.size,
                                  weight: FontWeightMapper.map(text.style.weight)))
                    .foregroundColor(Color(bdui: text.color))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
            }
            .disabled(!enabled)

        case .input(_, let label, let placeholder, _):
            VStack(alignment: .leading, spacing: 4) {
                Text(label.value)
                    .font(.caption)
                TextField(placeholder?.value ?? "", text: $inputText)
                    .textFieldStyle(.roundedBorder)
            }

        case .spacer:
            Spacer(minLength: 0)

        case .column(_, let children):
            VStack(alignment: .leading, spacing: 0) {
                ForEachIndexed(children) { child in
                    BduiComponentView(component: child, onAction: onAction)
                }
            }

        case .row(_, let children):
            HStack(alignment: .center, spacing: 0) {
                ForEachIndexed(children) { child in
                    BduiComponentView(component: child, onAction: onAction)
                }
            }

        case .box(_, let children):
            ZStack {
                ForEachIndexed(children) { child in
                    BduiComponentView(component: child, onAction: onAction)
                }
            }
        }
    }

    private func fire(_ actions: [BduiActionUI]?) {
        actions?.forEach(onAction)
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
