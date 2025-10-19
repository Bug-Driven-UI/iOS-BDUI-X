//
//  BduiInputView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI
import Combine

public struct BduiInputComponent: View {
    let component: BduiInputComponentModel
    let onAction: (BduiActionUiModel) -> Void

    @Environment(\.localLocalStates) private var store
    @State private var text: String = ""
    @State private var cancellable: AnyCancellable?

    public init(
        component: BduiInputComponentModel,
        onAction: @escaping (BduiActionUiModel) -> Void
    ) {
        self.component = component
        self.onAction = onAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    if text.isEmpty, let placeholder = component.placeholder {
                        Text(placeholder.value.asDisplayString)
                            .font(.system(size: CGFloat(placeholder.style.size),
                                          weight: FontWeightMapper.map(placeholder.style.weight)))
                            .foregroundStyle(placeholder.color.toColor().opacity(0.6))
                    }
                    TextField("", text: Binding(
                        get: { text },
                        set: { newValue in
                            text = newValue
                            onAction(.inputValueChanged(
                                .init(actions: component.onValueChangedActions, newInputValue: newValue)
                            ))
                        }
                    ))
                    .font(.system(size: CGFloat(component.text.style.size),
                                  weight: FontWeightMapper.map(component.text.style.weight)))
                    .foregroundStyle(component.text.color.toColor())
                }
                if let icon = component.rightIcon {
                    BduiImageComponent(component: icon)
                        .bduiBaseProperties(base: icon.baseProperties, onAction: { _ in })
                }
            }
            .frame(minHeight: 44)
            .padding(.horizontal, 16)
        }
        .onAppear { subscribeInitialAndUpdates() }
    }

    private func subscribeInitialAndUpdates() {
        switch component.text.value {
        case .text(let v): text = v
        case .localState(let path):
            guard let store else {
                text = ""
                return
            }
            cancellable = store
                .stringPublisher(for: path, initialValue: "")
                .receive(on: DispatchQueue.main)
                .sink { v in
                    if v != text { text = v }
                }
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
