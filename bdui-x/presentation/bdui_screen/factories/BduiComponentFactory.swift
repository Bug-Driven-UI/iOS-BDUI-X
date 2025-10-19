//
//  BduiComponentFactory.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public final class BduiComponentFactory {
    private let localStateResolver: LocalStateResolver
    private let mapper: BduiComponentPropertiesMapper

    public init(localStateResolver: LocalStateResolver,
                mapper: BduiComponentPropertiesMapper)
    {
        self.localStateResolver = localStateResolver
        self.mapper = mapper
    }

    public func create(component: RenderedComponentModel) -> BduiComponentUiModel {
        switch component {
        case .boxModel(let m): return createBoxComponent(m)
        case .buttonModel(let m): return createButtonComponent(m)
        case .columnModel(let m): return createColumnComponent(m)
        case .imageModel(let m): return createImageComponent(m)
        case .inputModel(let m): return createInputComponent(m)
        case .rowModel(let m): return createRowComponent(m)
        case .spacerModel(let m): return createSpacerComponent(m)
        case .switchModel:
            // Not supported yet
            fatalError("Switch component not supported yet")
        case .textModel(let m): return createTextComponent(m)
        }
    }

    // MARK: - Base properties (use top-level model types, not RenderedComponentModel.*)

    private func baseProperties(from m: RowModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: BoxModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: ColumnModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: TextModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: ImageModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: InputModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: SpacerModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    private func baseProperties(from m: SwitchModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    // MISSING BEFORE: ButtonModel overload
    private func baseProperties(from m: ButtonModel,
                                customize: (BduiBasePropertiesModel) -> BduiBasePropertiesModel = { $0 }) -> BduiBasePropertiesModel
    {
        customize(BduiBasePropertiesModel(
            id: m.id,
            hash: m.hash,
            interactions: mapper.toBduiInteractions(m.interactions),
            paddings: m.paddings.toComponentInsets(),
            margins: m.margins.toComponentInsets(),
            width: m.width.toComponentSize(),
            height: m.height.toComponentSize(),
            backgroundColor: m.backgroundColor.toBduiColor(),
            border: m.border.toBduiBorder(),
            shape: m.shape.toBduiShape()
        ))
    }

    // MARK: - Component builders

    private func createBoxComponent(_ component: BoxModel) -> BduiComponentUiModel {
        .boxModel(BduiBoxComponentModel(
            contentAlignment: component.contentAlignment.map(mapAlignment),
            baseProperties: baseProperties(from: component),
            children: component.children.map(create)
        ))
    }

    private func createRowComponent(_ component: RowModel) -> BduiComponentUiModel {
        .rowModel(BduiRowComponentModel(
            horizontalArrangement: component.horizontalArrangement.map(mapArrangement),
            verticalAlignment: component.verticalAlignment.map(mapAlignment),
            isScrollable: component.isScrollable ?? false,
            baseProperties: baseProperties(from: component),
            children: component.children.map(create)
        ))
    }

    private func createColumnComponent(_ component: ColumnModel) -> BduiComponentUiModel {
        .columnModel(BduiColumnComponentModel(
            verticalArrangement: component.verticalArrangement.map(mapArrangement),
            horizontalAlignment: component.horizontalAlignment.map(mapAlignment),
            baseProperties: baseProperties(from: component),
            children: component.children.map(create)
        ))
    }

    private func createTextComponent(_ component: TextModel) -> BduiComponentUiModel {
        .textModel(BduiTextComponentModel(
            baseProperties: baseProperties(from: component),
            text: mapper.toBduiText(component.textWithStyle)
        ))
    }

    private func createButtonComponent(_ component: ButtonModel) -> BduiComponentUiModel {
        .buttonModel(BduiButtonComponentModel(
            baseProperties: baseProperties(from: component),
            text: {
                // Wrap inner text component into UI Text
                switch create(component: .textModel(component.text)) {
                case .textModel(let t): return t
                default:
                    // Fallback: build directly
                    return BduiTextComponentModel(
                        baseProperties: baseProperties(from: component.text),
                        text: mapper.toBduiText(component.text.textWithStyle)
                    )
                }
            }(),
            enabled: component.enabled
        ))
    }

    private func createImageComponent(_ component: ImageModel) -> BduiComponentUiModel {
        // Mirror Android: strip background for image
        .imageModel(BduiImageComponentModel(
            baseProperties: baseProperties(from: component) { base in
                BduiBasePropertiesModel(
                    id: base.id,
                    hash: base.hash,
                    interactions: base.interactions,
                    paddings: base.paddings,
                    margins: base.margins,
                    width: base.width,
                    height: base.height,
                    backgroundColor: nil,
                    border: base.border,
                    shape: base.shape
                )
            },
            imageUrl: component.imageUrl
        ))
    }

    private func createInputComponent(_ component: InputModel) -> BduiComponentUiModel {
        .inputModel(BduiInputComponentModel(
            baseProperties: baseProperties(from: component),
            text: mapper.toBduiText(component.textWithStyle),
            // FIX: avoid Optional.map on RenderedStyledTextRepresentationModel via optional chaining
            placeholder: component.placeholder.map { mapper.toBduiText($0.textWithStyle) },
            rightIcon: component.rightIcon.map { right in
                switch create(component: .imageModel(right)) {
                case .imageModel(let img): return img
                default:
                    return BduiImageComponentModel(
                        baseProperties: baseProperties(from: right),
                        imageUrl: right.imageUrl
                    )
                }
            },
            onValueChangedActions: (component.onValueChanged ?? []).compactMap { action in
                switch action {
                case .setLocalStateFromInput(let a):
                    if let path = localStateResolver.resolveRawPath(a.target) {
                        return .setLocalStateFromInput(.init(targetPath: .init(path)))
                    }
                    return nil
                default:
                    return nil
                }
            }
        ))
    }

    private func createSpacerComponent(_ component: SpacerModel) -> BduiComponentUiModel {
        .spacerModel(BduiSpacerComponentModel(baseProperties: baseProperties(from: component)))
    }

    // MARK: - Alignments/arrangements mapping

    private func mapArrangement(_ a: RenderedHorizontalArrangement) -> BduiHorizontalArrangementModel {
        switch a {
        case .start: return .start
        case .end: return .end
        case .center: return .center
        case .spaceBetween: return .spaceBetween
        case .spaceEvenly: return .spaceEvenly
        case .spaceAround: return .spaceAround
        }
    }

    private func mapArrangement(_ a: RenderedVerticalArrangement) -> BduiVerticalArrangementModel {
        switch a {
        case .top: return .top
        case .bottom: return .bottom
        case .center: return .center
        case .spaceBetween: return .spaceBetween
        case .spaceEvenly: return .spaceEvenly
        case .spaceAround: return .spaceAround
        }
    }

    private func mapAlignment(_ a: RenderedHorizontalAlignment) -> BduiHorizontalAlignmentModel {
        switch a {
        case .start: return .start
        case .center: return .center
        case .end: return .end
        }
    }

    private func mapAlignment(_ a: RenderedVerticalAlignment) -> BduiVerticalAlignmentModel {
        switch a {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }

    private func mapAlignment(_ a: RenderedHorizontalAndVerticalAlignment) -> BduiHorizontalAndVerticalAlignmentModel {
        switch a {
        case .topStart: return .topStart
        case .topCenter: return .topCenter
        case .topEnd: return .topEnd
        case .centerStart: return .centerStart
        case .center: return .center
        case .centerEnd: return .centerEnd
        case .bottomStart: return .bottomStart
        case .bottomCenter: return .bottomCenter
        case .bottomEnd: return .bottomEnd
        }
    }
}
