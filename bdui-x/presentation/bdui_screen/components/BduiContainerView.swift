//
//  BduiContainerView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import Combine
import SwiftUI

public struct BduiContainerComponent: View {
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
        case .boxModel(let m):
            ZStack(alignment: m.contentAlignment.toSwiftUI()) {
                ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                    BduiComponent(component: child, onAction: onAction)
                        .bduiBaseProperties(
                            base: child.basePropertiesValue,
                            onAction: onAction,
                            buttonEnabled: child.buttonEnabledValue
                        )
                }
            }

        case .columnModel(let m):
            ColumnModelBody(m: m, onAction: onAction)

        case .rowModel(let m):
            if m.isScrollable {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: m.verticalAlignment.toSwiftUI(), spacing: 0) {
                        ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                            BduiComponent(component: child, onAction: onAction)
                                .bduiBaseProperties(
                                    base: child.basePropertiesValue,
                                    onAction: onAction,
                                    buttonEnabled: child.buttonEnabledValue
                                )
                        }
                    }
                }

            } else {
                HStack(alignment: m.verticalAlignment.toSwiftUI(), spacing: 0) {
                    ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                        BduiComponent(component: child, onAction: onAction)
                            .bduiBaseProperties(
                                base: child.basePropertiesValue,
                                onAction: onAction,
                                buttonEnabled: child.buttonEnabledValue
                            )
                            .applyWidthWeight(child.widthWeight)
                    }
                }
            }

        default:
            EmptyView()
        }
    }
}

// MARK: - Alignment mappers for containers

private extension Optional where Wrapped == BduiHorizontalAndVerticalAlignmentModel {
    func toSwiftUI() -> Alignment {
        switch self {
        case .some(.topStart): return .topLeading
        case .some(.topCenter): return .top
        case .some(.topEnd): return .topTrailing
        case .some(.centerStart): return .leading
        case .some(.center): return .center
        case .some(.centerEnd): return .trailing
        case .some(.bottomStart): return .bottomLeading
        case .some(.bottomCenter): return .bottom
        case .some(.bottomEnd): return .bottomTrailing
        case .none: return .topLeading
        }
    }
}

private extension Optional where Wrapped == BduiHorizontalAlignmentModel {
    func toSwiftUI() -> HorizontalAlignment {
        switch self {
        case .some(.start): return .leading
        case .some(.center): return .center
        case .some(.end): return .trailing
        case .none: return .leading
        }
    }
}

private extension Optional where Wrapped == BduiVerticalAlignmentModel {
    func toSwiftUI() -> VerticalAlignment {
        switch self {
        case .some(.top): return .top
        case .some(.center): return .center
        case .some(.bottom): return .bottom
        case .none: return .top
        }
    }
}

// MARK: - Child helpers

private extension BduiComponentUiModel {
    var basePropertiesValue: BduiBasePropertiesModel {
        switch self {
        case .textModel(let m): return m.baseProperties
        case .imageModel(let m): return m.baseProperties
        case .buttonModel(let m): return m.baseProperties
        case .inputModel(let m): return m.baseProperties
        case .spacerModel(let m): return m.baseProperties
        case .rowModel(let m): return m.baseProperties
        case .columnModel(let m): return m.baseProperties
        case .boxModel(let m): return m.baseProperties
        }
    }

    var buttonEnabledValue: Bool? {
        switch self {
        case .buttonModel(let m): return m.enabled
        default: return nil
        }
    }

    var widthWeight: CGFloat? {
        switch self {
        case .textModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .imageModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .buttonModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .inputModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .spacerModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .rowModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .columnModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        case .boxModel(let m): if case .weighted(let f) = m.baseProperties.width { return CGFloat(f) }
        }
        return nil
    }

    var heightWeight: CGFloat? {
        switch self {
        case .textModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .imageModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .buttonModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .inputModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .spacerModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .rowModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .columnModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        case .boxModel(let m): if case .weighted(let f) = m.baseProperties.height { return CGFloat(f) }
        }
        return nil
    }
}

// MARK: - Base properties as a ViewModifier (padding, background, border, size, margins, interactions)

public extension View {
    func bduiBaseProperties(
        base: BduiBasePropertiesModel,
        onAction: @escaping (BduiActionUiModel) -> Void,
        buttonEnabled: Bool? = nil
    ) -> some View {
        modifier(BduiBasePropertiesModifier(base: base, buttonEnabled: buttonEnabled, onAction: onAction))
    }
}

private struct BduiBasePropertiesModifier: ViewModifier {
    let base: BduiBasePropertiesModel
    let buttonEnabled: Bool?
    let onAction: (BduiActionUiModel) -> Void

    @State private var didSendOnShow = false

    func body(content: Content) -> some View {
        let shape = backgroundShape()

        let inner = content
            .padding(base.paddings.toEdgeInsets())
            .background(shape.fill(base.backgroundColor?.toColor() ?? .clear))
            .overlay(borderOverlay(with: shape))
            .clipShape(shape)

        let sized = inner
            .applyWidth(base.width)
            .applyHeight(base.height)

        let withMargins = sized.padding(base.margins.toEdgeInsets())

        return withMargins
            .contentShape(Rectangle())
            .onTapGesture {
                guard buttonEnabled ?? true else { return }
                trigger(base.interactions?.onClick)
            }
            .onAppear {
                // Defer onShow to avoid "Modifying state during view update"
                if !didSendOnShow {
                    didSendOnShow = true
                    DispatchQueue.main.async {
                        trigger(base.interactions?.onShow)
                    }
                }
            }
    }

    private func trigger(_ actions: [BduiActionUiModel]?) {
        guard let actions, !actions.isEmpty else { return }
        actions.forEach(onAction)
    }

    private func backgroundShape() -> AnyShapeCompat {
        if let s = base.shape {
            switch s {
            case .roundedCorners(let rc):
                return AnyShapeCompat(RoundedCornersShape(
                    tl: CGFloat(rc.topStart),
                    tr: CGFloat(rc.topEnd),
                    bl: CGFloat(rc.bottomStart),
                    br: CGFloat(rc.bottomEnd)
                ))
            }
        }
        return AnyShapeCompat(Rectangle())
    }

    @ViewBuilder
    private func borderOverlay(with shape: AnyShapeCompat) -> some View {
        if let border = base.border {
            shape
                .stroke(border.color.toColor(), lineWidth: CGFloat(border.thickness))
        } else {
            EmptyView()
        }
    }
}

private struct AnyShapeCompat: Shape {
    private let _path: (CGRect) -> SwiftUI.Path
    init<S: Shape>(_ wrapped: S) { _path = { rect in wrapped.path(in: rect) } }
    func path(in rect: CGRect) -> SwiftUI.Path { _path(rect) }
}

// MARK: - Layout helpers

private extension View {
    func applyWidth(_ size: BduiComponentSizeModel) -> some View {
        switch size {
        case .fixed(let v): return AnyView(frame(width: CGFloat(v)))
        case .weighted: return AnyView(frame(maxWidth: .infinity))
        case .matchParent: return AnyView(frame(maxWidth: .infinity))
        case .wrapContent: return AnyView(self)
        }
    }

    func applyHeight(_ size: BduiComponentSizeModel) -> some View {
        switch size {
        case .fixed(let v): return AnyView(frame(height: CGFloat(v)))
        case .weighted: return AnyView(frame(maxHeight: .infinity))
        case .matchParent: return AnyView(frame(maxHeight: .infinity))
        case .wrapContent: return AnyView(self)
        }
    }
}

private extension Optional where Wrapped == BduiComponentInsetsUiModel {
    func toEdgeInsets() -> EdgeInsets {
        guard let s = self else { return EdgeInsets() }
        return EdgeInsets(top: CGFloat(s.top), leading: CGFloat(s.start), bottom: CGFloat(s.bottom), trailing: CGFloat(s.end))
    }
}

private extension View {
    @ViewBuilder
    func applyHeightWeight(_ weight: CGFloat?) -> some View {
        if let w = weight {
            frame(maxHeight: .infinity)
                .layoutPriority(Double(max(0.0, min(1.0, w))))
        } else {
            self
        }
    }
}

struct ColumnModelBody: View {
    let m: BduiColumnComponentModel
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        VStack(alignment: m.horizontalAlignment.toSwiftUI(), spacing: 0) {
            ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                BduiComponent(component: child, onAction: onAction)
                    .bduiBaseProperties(
                        base: child.basePropertiesValue,
                        onAction: onAction,
                        buttonEnabled: child.buttonEnabledValue
                    )
                    .applyHeightWeight(child.heightWeight)
            }
        }
        .bduiBaseProperties(base: m.baseProperties, onAction: onAction)
    }
}

private extension View {
    @ViewBuilder
    func applyWidthWeight(_ weight: CGFloat?) -> some View {
        if let w = weight {
            frame(maxWidth: .infinity)
                .layoutPriority(Double(max(0.0, min(1.0, w))))
        } else {
            self
        }
    }
}
