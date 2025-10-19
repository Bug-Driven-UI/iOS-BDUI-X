//
//  BduiComponentPropertiesMapper.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation
import SwiftUI


// MARK: - Properties mapper (Rendered -> UI tokens)

public final class BduiComponentPropertiesMapper {

    private let localStateResolver: LocalStateResolver

    public init(localStateResolver: LocalStateResolver) {
        self.localStateResolver = localStateResolver
    }

    public func toBduiText(_ model: RenderedStyledTextRepresentationModel) -> BduiTextModel {
        let value: TextOrLocalStateModel = {
            if let path = localStateResolver.resolveRawPath(model.textOrLocalState) {
                return .localState(path: path)
            } else {
                return .text(model.textOrLocalState)
            }
        }()

        let color = model.textColorStyle.toBduiColor()
        let style = model.textStyle.toBduiTextStyle()
        let alignment: BduiTextAlignmentModel? = model.textAlignment.map {
            switch $0 {
            case .start: return .start
            case .center: return .center
            case .end: return .end
            }
        }

        return BduiTextModel(
            value: value,
            color: color,
            style: style,
            textAlignment: alignment
        )
    }

    public func toBduiInteractions(_ model: [RenderedInteractionModel]) -> BduiComponentInteractionsUiModel {
        BduiComponentInteractionsUiModel(
            onClick: toBduiInteractionActions(model, interactionType: .onClick),
            onShow: toBduiInteractionActions(model, interactionType: .onShow)
        )
    }

    public func toBduiInteractionActions(
        _ model: [RenderedInteractionModel],
        interactionType: RenderedInteractionModel.InteractionType
    ) -> [BduiActionUiModel]? {
        model.first(where: { $0.type == interactionType }).map(toBduiInteractionActions(_:))
    }

    public func toBduiInteractionActions(_ model: RenderedInteractionModel) -> [BduiActionUiModel] {
        var actions: [BduiActionUiModel] = []
        var remote: [BduiRemoteActionModel] = []

        model.actions.forEach { action in
            switch action {
            case .command(let a):
                remote.append(.command(.init(name: a.name, params: a.params)))
            case .updateScreen(let a):
                remote.append(.updateScreen(.init(screenName: a.screenName, screenNavigationParams: a.screenNavigationParams)))
            case .navigateBack(let a):
                actions.append(.navigateBack(.init(updatePreviousScreen: a.updatePreviousScreen)))
            case .navigateTo(let a):
                actions.append(.navigateTo(.init(screenName: a.screenName, screenNavigationParams: a.screenNavigationParams, toBottomSheet: false)))
            case .navigateToBottomSheet(let a):
                actions.append(.navigateTo(.init(screenName: a.screenName, screenNavigationParams: a.screenNavigationParams, toBottomSheet: true)))
            case .setLocalState(let a):
                if let path = localStateResolver.resolveRawPath(a.target) {
                    actions.append(.setLocalState(.init(targetPath: .init(path), newValue: a.value)))
                }
            case .setLocalStateFromInput:
                break
            }
        }

        if !remote.isEmpty {
            actions.append(.sendRemoteActions(.init(actions: remote)))
        }

        let (navigation, other) = actions.partitioned { act in
            switch act {
            case .navigateBack, .navigateTo: return true
            default: return false
            }
        }
        return other + navigation
    }
}

// MARK: - Rendered -> UI atomic mappers

public extension Optional where Wrapped == RenderedColorStyleModel {
    func toBduiColor(fallbackColor: BduiColorModel = BduiColorModel(hex: "#FFFFFF")) -> BduiColorModel {
        guard let s = self else { return fallbackColor }
        return BduiColorModel(hex: s.hex)
    }
    
    func toBduiColor(fallback: BduiColorModel) -> BduiColorModel {
        toBduiColor(fallbackColor: fallback)
    }
}

public extension RenderedColorStyleModel {
    // Convenience for non-optional usage
    func toBduiColor() -> BduiColorModel { BduiColorModel(hex: hex) }
}

public extension Optional where Wrapped == RenderedInsetsModel {
    func toComponentInsets() -> BduiComponentInsetsUiModel {
        BduiComponentInsetsUiModel(
            start: self?.start ?? 0,
            end: self?.end ?? 0,
            top: self?.top ?? 0,
            bottom: self?.bottom ?? 0
        )
    }
}

public extension RenderedSizeModel {
    func toComponentSize() -> BduiComponentSizeModel {
        switch self {
        case .fixed(let v): return .fixed(v.value)
        case .weighted(let v): return .weighted(Double(v.fraction))
        case .matchParent: return .matchParent
        case .wrapContent: return .wrapContent
        }
    }
}

public extension RenderedTextStyleModel {
    func toBduiTextStyle() -> BduiTextStyleModel {
        let decoration: BduiTextDecorationTypeModel = {
            switch self.decoration {
            case .italic?: return .italic
            case .underline?: return .underline
            case .strikethrough?: return .strikethrough
            case .strikethroughRed?: return .strikethroughRed
            case .regular?: return .regular
            case nil: return .regular
            }
        }()
        return BduiTextStyleModel(
            decorationType: decoration,
            weight: self.weight ?? 400,
            size: self.size
        )
    }
}

public extension Optional where Wrapped == RenderedBorderModel {
    func toBduiBorder() -> BduiBorderModel? {
        guard let s = self else { return nil }
        return BduiBorderModel(color: s.color.toBduiColor(), thickness: s.thickness)
    }
}

public extension Optional where Wrapped == RenderedShapeModel {
    func toBduiShape() -> BduiShapeModel? {
        guard let s = self else { return nil }
        switch s.type {
        case .roundedCorners:
            return .roundedCorners(.init(
                topStart: s.topLeft,
                topEnd: s.topRight,
                bottomStart: s.bottomLeft,
                bottomEnd: s.bottomRight
            ))
        }
    }
}

// MARK: - Small utils

private extension Array {
    func partitioned(_ belongsInFirst: (Element) -> Bool) -> ([Element], [Element]) {
        var first: [Element] = []
        var second: [Element] = []
        for el in self {
            if belongsInFirst(el) { first.append(el) } else { second.append(el) }
        }
        return (first, second)
    }
}
