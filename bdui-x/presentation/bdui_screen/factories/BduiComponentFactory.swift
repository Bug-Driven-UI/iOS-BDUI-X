//
//  BduiComponentFactory.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import Foundation

final class BduiComponentFactory {

    func create(_ rendered: RenderedComponent) -> BduiComponentUI {
        switch rendered {

        case .column(let model):
            return .column(
                base: baseProperties(from: model),
                children: model.children.map(create)
            )

        case .row(let model):
            return .row(
                base: baseProperties(from: model),
                children: model.children.map(create)
            )

        case .box(let model):
            return .box(
                base: baseProperties(from: model),
                children: model.children.map(create)
            )

        case .text(let model):
            return .text(
                base: baseProperties(from: model),
                text: model.textWithStyle.toBduiText()
            )

        case .image(let model):
            var base = baseProperties(from: model)
            // Kotlin logic cleared image background; mirror that:
            base = base.withBackground(nil)
            return .image(
                base: base,
                url: model.imageUrl
            )

        case .input(let model):
            return .input(
                base: baseProperties(from: model),
                text: model.textWithStyle.toBduiText(),
                placeholder: model.placeholder?.textWithStyle.toBduiText(),
                hint: model.hint?.textWithStyle.toBduiText()
            )

        case .button(let model):
            return .button(
                base: baseProperties(from: model),
                text: model.textWithStyle.toBduiText(),
                enabled: model.enabled
            )

        case .spacer(let model):
            return .spacer(
                base: baseProperties(from: model)
            )

        case .switch(let model):
  
            fatalError("Switch component mapping not implemented. Add a .switch case to BduiComponentUI.")
        }
    }

    // MARK: - Base builder

    private func baseProperties(from model: any RenderedComponentCommon) -> BduiComponentBaseProperties {
        BduiComponentBaseProperties(
            id: model.id,
            hash: model.hash,
            interactions: model.interactions.toBduiInteractions(),
            paddings: model.paddings?.toBduiInsets(),
            margins: model.margins?.toBduiInsets(),
            width: model.width.toBduiSize(),
            height: model.height.toBduiSize(),
            backgroundColor: model.backgroundColor?.toBduiColor(),
            border: model.border?.toBduiBorder(),
            shape: model.shape?.toBduiShape()
        )
    }
}

// MARK: - Small mutating helper

private extension BduiComponentBaseProperties {
    func withBackground(_ color: BduiColor?) -> BduiComponentBaseProperties {
        BduiComponentBaseProperties(
            id: id,
            hash: hash,
            interactions: interactions,
            paddings: paddings,
            margins: margins,
            width: width,
            height: height,
            backgroundColor: color,
            border: border,
            shape: shape
        )
    }
}
extension RenderedColorStyleModel {
    func toBduiColor() -> BduiColor {
        BduiColor(hex: hex)
    }
}

// MARK: - Insets

extension RenderedInsetsModel {
    func toBduiInsets() -> BduiComponentInsetsUI {
        BduiComponentInsetsUI(
            start: CGFloat(left),
            end: CGFloat(right),
            top: CGFloat(top),
            bottom: CGFloat(bottom)
        )
    }
}

// MARK: - Size

extension RenderedSizeModel {
    func toBduiSize() -> BduiComponentSize {
        switch self {
        case .fixed(let value):
            return .fixed(CGFloat(value))
        case .weighted(let fraction):
            return .weighted(CGFloat(fraction))
        case .matchParent:
            return .matchParent
        case .wrapContent:
            return .wrapContent
        }
    }
}

// MARK: - Shape

extension RenderedShapeModel {
    func toBduiShape() -> BduiShape.RoundedCorners? {
        switch type {
        case .roundedCorners:
            return BduiShape.RoundedCorners(
                topStart: CGFloat(topLeft),
                topEnd: CGFloat(topRight),
                bottomStart: CGFloat(bottomLeft),
                bottomEnd: CGFloat(bottomRight)
            )
        }
    }
}

// MARK: - Border

extension RenderedBorderModel {
    func toBduiBorder() -> BduiBorder {
        BduiBorder(
            color: color.toBduiColor(),
            thickness: CGFloat(thickness)
        )
    }
}

// MARK: - Text Decoration

extension RenderedTextDecorationTypeModel {
    func toBduiDecoration() -> BduiTextDecorationType {
        switch self {
        case .italic: return .italic
        case .underline: return .underline
        case .strikeThrough: return .strikethrough
        case .strikeThroughRed: return .strikethroughRed
        case .regular: return .regular
        }
    }
}

// MARK: - Text Style

extension RenderedTextStyleModel {
    func toBduiTextStyle() -> BduiTextStyle {
        BduiTextStyle(
            decoration: decoration?.toBduiDecoration() ?? .regular,
            weight: weight ?? 400,
            size: CGFloat(size)
        )
    }
}

// MARK: - Styled Text

extension RenderedStyledTextRepresentationModel {
    func toBduiText() -> BduiText {
        BduiText(
            value: text,
            color: colorStyle.toBduiColor(),
            style: textStyle.toBduiTextStyle()
        )
    }
}

// MARK: - Actions / Interactions

extension RenderedActionModel {
    func toRemote() -> BduiActionUI.Remote {
        switch self {
        case .command(let cmd):
            return .command(name: cmd.name, params: cmd.params)
        case .updateScreen(let upd):
            return .updateScreen(name: upd.screenName,
                                 params: upd.screenNavigationParams)
        }
    }
}

extension Array where Element == RenderedInteractionModel {
    func toBduiInteractions() -> BduiComponentInteractionsUI? {
        let onClick = actions(for: .onClick)
        let onShow = actions(for: .onShow)
        if onClick == nil && onShow == nil {
            return nil
        }
        return BduiComponentInteractionsUI(onClick: onClick, onShow: onShow)
    }

    func actions(for type: RenderedInteractionModel.InteractionType) -> [BduiActionUI]? {
        guard let model = first(where: { $0.type == type }) else { return nil }
        if model.actions.isEmpty { return nil }
        let remotes = model.actions.map { $0.toRemote() }
        return [.sendRemoteActions(remotes)]
    }
}
