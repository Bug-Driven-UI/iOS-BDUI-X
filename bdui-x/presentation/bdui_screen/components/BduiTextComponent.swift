//
//  BduiTextComponent.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import SwiftUI

public struct BduiTextComponent: View {
    let component: BduiTextComponentModel

    public init(component: BduiTextComponentModel) {
        self.component = component
    }

    public var body: some View {
        let textValue = component.text.value.asDisplayString

        if component.text.style.decorationType == .strikethroughRed {
            RedStrikethroughText(
                text: textValue,
                style: component.text,
                base: component.baseProperties
            )
        } else {
            Text(textValue)
                .font(.system(size: CGFloat(component.text.style.size),
                              weight: FontWeightMapper.map(component.text.style.weight)))
                .foregroundStyle(component.text.color.toColor())
                .multilineTextAlignment(component.text.textAlignment.toSwiftUI())
        }
    }
}

private struct RedStrikethroughText: View {
    let text: String
    let style: BduiTextModel
    let base: BduiBasePropertiesModel

    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: CGFloat(style.style.size),
                              weight: FontWeightMapper.map(style.style.weight)))
                .foregroundStyle(style.color.toColor())
                .multilineTextAlignment(style.textAlignment.toSwiftUI())

            GeometryReader { proxy in
                let y = proxy.size.height / 2.0
                SwiftUI.Path { p in
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: proxy.size.width, y: y))
                }
                .stroke(Color(red: 1.0, green: 0.25, blue: 0.325), lineWidth: 1.5)
            }
        }
        .bduiBaseProperties(base: base, onAction: { _ in })
    }
}

private extension Optional where Wrapped == BduiTextAlignmentModel {
    func toSwiftUI() -> TextAlignment {
        switch self {
        case .some(.start): return .leading
        case .some(.center): return .center
        case .some(.end): return .trailing
        case .none: return .leading
        }
    }
}
private extension TextOrLocalStateModel {
    var asDisplayString: String {
        switch self {
        case .text(let v): return v
        case .localState(let path): return "#{\(path)}"
        }
    }
}
