//
//  BduiComponentView.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

public struct BduiComponent: View {
    let component: BduiComponentUiModel
    let onAction: (BduiActionUiModel) -> Void

    public init(
        component: BduiComponentUiModel,
        onAction: @escaping (BduiActionUiModel) -> Void
    ) {
        self.component = component
        self.onAction = onAction
    }

    public var body: some View {
        switch component {
        case .rowModel, .columnModel, .boxModel:
            BduiContainerComponent(component: component, onAction: onAction)

        case .buttonModel(let m):
            BduiButtonComponent(component: m, onAction: onAction)

        case .imageModel(let m):
            BduiImageComponent(component: m)

        case .inputModel(let m):
            BduiInputComponent(component: m, onAction: onAction)

        case .textModel(let m):
            BduiTextComponent(component: m)

        case .spacerModel(let m):
            BduiSpacerComponent(component: m)
        }
    }
}
