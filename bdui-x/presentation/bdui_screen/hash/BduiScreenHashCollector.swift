//
//  BduiScreenHashCollector.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public final class BduiScreenHashCollector {
    public init() {}

    // Collect hash tree for a list of components (root level)
    public func collect(componentTree: [BduiComponentUiModel]) -> [HashNodeModel] {
        componentTree.map(collect)
    }

    // Collect hash node for a single component
    public func collect(_ component: BduiComponentUiModel) -> HashNodeModel {
        HashNodeModel(
            id: component.baseId,
            hash: component.baseHash,
            children: component.containerChildren?.map(collect) ?? []
        )
    }
}

private extension BduiComponentUiModel {
    var baseId: String {
        switch self {
        case .textModel(let m): return m.baseProperties.id
        case .imageModel(let m): return m.baseProperties.id
        case .buttonModel(let m): return m.baseProperties.id
        case .inputModel(let m): return m.baseProperties.id
        case .spacerModel(let m): return m.baseProperties.id
        case .rowModel(let m): return m.baseProperties.id
        case .columnModel(let m): return m.baseProperties.id
        case .boxModel(let m): return m.baseProperties.id
        }
    }

    var baseHash: String {
        switch self {
        case .textModel(let m): return m.baseProperties.hash
        case .imageModel(let m): return m.baseProperties.hash
        case .buttonModel(let m): return m.baseProperties.hash
        case .inputModel(let m): return m.baseProperties.hash
        case .spacerModel(let m): return m.baseProperties.hash
        case .rowModel(let m): return m.baseProperties.hash
        case .columnModel(let m): return m.baseProperties.hash
        case .boxModel(let m): return m.baseProperties.hash
        }
    }

    var containerChildren: [BduiComponentUiModel]? {
        switch self {
        case .rowModel(let m): return m.children
        case .columnModel(let m): return m.children
        case .boxModel(let m): return m.children
        default: return nil
        }
    }
}
