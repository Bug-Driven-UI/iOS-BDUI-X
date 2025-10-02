//
//  BduiScreenHashCollector.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//
import Foundation

final class BduiScreenHashCollector {
    func collect(componentTree: [BduiComponentUI]) -> [HashNode] {
        componentTree.map(collectInternal)
    }

    private func collectInternal(_ component: BduiComponentUI) -> HashNode {
        let children: [HashNode]
        switch component {
        case .column(_, let c),
             .row(_, let c),
             .box(_, let c):
            children = c.map(collectInternal)
        default:
            children = []
        }
        return HashNode(
            id: component.base.id,
            hash: component.base.hash,
            children: children
        )
    }
}
