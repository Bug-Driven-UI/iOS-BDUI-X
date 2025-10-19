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
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

        case .columnModel(let m):
            ColumnModelBody(m: m, onAction: onAction)

        case .rowModel(let m):
            if m.isScrollable {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: m.verticalAlignment.toSwiftUI(), spacing: 8) {
                        ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                            rowChildView(child)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                let hasExplicitSpacer = m.children.contains { if case .spacerModel = $0 { return true } else { return false } }
                let arrangement = m.horizontalArrangement

                if usesFlexibleSpacing(arrangement), !hasExplicitSpacer {
                    HStack(alignment: m.verticalAlignment.toSwiftUI(), spacing: 0) {
                        if arrangement == .center || arrangement == .end || arrangement == .spaceEvenly || arrangement == .spaceAround {
                            Spacer(minLength: 0) 
                        }

                        ForEach(Array(m.children.enumerated()), id: \.0) { idx, child in
                            rowChildView(child)

                            if idx < m.children.count - 1, arrangement == .spaceBetween || arrangement == .spaceEvenly || arrangement == .spaceAround {
                                Spacer(minLength: 0)
                            }
                        }

                        if arrangement == .center || arrangement == .spaceEvenly || arrangement == .spaceAround {
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                } else {
                    // Fallback: plain row with fixed spacing (start-aligned or when explicit spacers are present)
                    HStack(alignment: m.verticalAlignment.toSwiftUI(), spacing: 8) {
                        // For end/center without flexible mode (because of explicit spacers), add manual leading/trailing spacers
                        if arrangement == .center && hasExplicitSpacer == false { Spacer(minLength: 0) }
                        if arrangement == .end && hasExplicitSpacer == false { Spacer(minLength: 0) }

                        ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                            rowChildView(child)
                        }

                        if arrangement == .center && hasExplicitSpacer == false { Spacer(minLength: 0) }
                    }
                    .frame(maxWidth: .infinity, alignment: arrangement == .end ? .trailing : (arrangement == .center ? .center : .leading))
                }
            }

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func rowChildView(_ child: BduiComponentUiModel) -> some View {
        switch child {
        case .spacerModel(let m):
            // If spacer has fixed width/height, honor width; otherwise flex
            switch m.baseProperties.width {
            case .fixed(let w): Spacer().frame(width: CGFloat(w))
            case .weighted, .matchParent: Spacer(minLength: 0)
            case .wrapContent: Spacer(minLength: 0)
            }

        case .buttonModel, .textModel, .imageModel, .inputModel, .rowModel, .columnModel, .boxModel:
            BduiComponent(component: child, onAction: onAction)
                .bduiBaseProperties(
                    base: child.basePropertiesValue,
                    onAction: onAction,
                    buttonEnabled: child.buttonEnabledValue
                )
                .fixedSize(horizontal: false, vertical: true)
                .applyWidthWeight(child.widthWeight)
        }
    }
}

private extension View {
    @ViewBuilder
    func applyWidthWeight(_ weight: CGFloat?) -> some View {
        if let _ = weight {
            frame(maxWidth: .infinity)
        } else {
            self
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

        let padded = content
            .padding(base.paddings.toEdgeInsets())

        let sized = padded
            .applyWidth(base.width)
            .applyHeight(base.height)

        let decorated = sized
            .background(shape.fill(base.backgroundColor?.toColor() ?? .clear))
            .overlay(borderOverlay(with: shape))
            .clipShape(shape)

        return decorated
            .padding(base.margins.toEdgeInsets())
            .contentShape(Rectangle())
            .onTapGesture {
                guard buttonEnabled ?? true else { return }
                trigger(base.interactions?.onClick)
            }
            .onAppear {
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

// MARK: - Layout helpers (iOS 13+ compatible)

private extension View {
    func applyWidth(_ size: BduiComponentSizeModel) -> some View {
        switch size {
        case .fixed(let v): return AnyView(frame(width: CGFloat(v)))
        case .weighted, .matchParent: return AnyView(frame(maxWidth: .infinity))
        case .wrapContent: return AnyView(self)
        }
    }

    func applyHeight(_ size: BduiComponentSizeModel) -> some View {
        switch size {
        case .fixed(let v): return AnyView(frame(height: CGFloat(v)))
        case .weighted, .matchParent, .wrapContent:
            return AnyView(self)
        }
    }
}

private func usesFlexibleSpacing(_ arrangement: BduiHorizontalArrangementModel?) -> Bool {
    guard let a = arrangement else { return false }
    switch a {
    case .spaceBetween, .spaceEvenly, .spaceAround, .center, .end: return true
    case .start: return false
    }
}

private func usesFlexibleSpacing(_ arrangement: BduiVerticalArrangementModel?) -> Bool {
    guard let a = arrangement else { return false }
    switch a {
    case .spaceBetween, .spaceEvenly, .spaceAround, .center, .bottom: return true
    case .top: return false
    }
}

private extension Optional where Wrapped == BduiComponentInsetsUiModel {
    func toEdgeInsets() -> EdgeInsets {
        guard let s = self else { return EdgeInsets() }
        return EdgeInsets(top: CGFloat(s.top), leading: CGFloat(s.start), bottom: CGFloat(s.bottom), trailing: CGFloat(s.end))
    }
}

struct ColumnModelBody: View {
    let m: BduiColumnComponentModel
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        let hasExplicitSpacer = m.children.contains { if case .spacerModel = $0 { return true } else { return false } }
        let arrangement = m.verticalArrangement

        if usesFlexibleSpacing(arrangement), !hasExplicitSpacer {
            VStack(alignment: m.horizontalAlignment.toSwiftUI(), spacing: 0) {
                if arrangement == .center || arrangement == .bottom || arrangement == .spaceEvenly || arrangement == .spaceAround {
                    Spacer(minLength: 0) // top spacer for center/bottom/evenly/around
                }

                ForEach(Array(m.children.enumerated()), id: \.0) { idx, child in
                    BduiComponent(component: child, onAction: onAction)
                        .bduiBaseProperties(
                            base: child.basePropertiesValue,
                            onAction: onAction,
                            buttonEnabled: child.buttonEnabledValue
                        )
                        .fixedSize(horizontal: false, vertical: true)

                    if idx < m.children.count - 1, arrangement == .spaceBetween || arrangement == .spaceEvenly || arrangement == .spaceAround {
                        Spacer(minLength: 0)
                    }
                }

                if arrangement == .center || arrangement == .spaceEvenly || arrangement == .spaceAround {
                    Spacer(minLength: 0) // bottom spacer for center/evenly/around
                }
                // For .bottom, we added only top Spacer to push content down.
                // For .top (default), no extra spacers.
            }
            .bduiBaseProperties(base: m.baseProperties, onAction: onAction)
        } else {
            VStack(alignment: m.horizontalAlignment.toSwiftUI(), spacing: 8) {
                if arrangement == .center && hasExplicitSpacer == false { Spacer(minLength: 0) }
                if arrangement == .bottom && hasExplicitSpacer == false { Spacer(minLength: 0) }

                ForEach(Array(m.children.enumerated()), id: \.0) { _, child in
                    BduiComponent(component: child, onAction: onAction)
                        .bduiBaseProperties(
                            base: child.basePropertiesValue,
                            onAction: onAction,
                            buttonEnabled: child.buttonEnabledValue
                        )
                        .fixedSize(horizontal: false, vertical: true)
                }

                if arrangement == .center && hasExplicitSpacer == false { Spacer(minLength: 0) }
            }
            .bduiBaseProperties(base: m.baseProperties, onAction: onAction)
        }
    }
}
