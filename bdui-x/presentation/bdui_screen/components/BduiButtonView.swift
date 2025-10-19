//
//  BduiButtonView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

public struct BduiButtonComponent: View {
    let component: BduiButtonComponentModel
    let onAction: (BduiActionUiModel) -> Void

    public init(
        component: BduiButtonComponentModel,
        onAction: @escaping (BduiActionUiModel) -> Void
    ) {
        self.component = component
        self.onAction = onAction
    }

    public var body: some View {
        let content = BduiTextComponent(component: component.text)
                .lineLimit(1)
                .truncationMode(.tail)
                .fixedSize(horizontal: false, vertical: true)
        


        content
            .bduiBaseProperties(
                base: component.baseProperties,
                onAction: onAction,
                buttonEnabled: component.enabled
            )
            .contentShape(Rectangle())
            .allowsHitTesting(component.enabled)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct BduiTextLeaf: View {
    let component: BduiTextComponentModel

    var body: some View {
        Text(component.text.value.asDisplayString)
            .font(.system(size: CGFloat(component.text.style.size),
                          weight: FontWeightMapper.map(component.text.style.weight)))
            .foregroundStyle(component.text.color.toColor())
            .multilineTextAlignment(component.text.textAlignment.toSwiftUI())
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
