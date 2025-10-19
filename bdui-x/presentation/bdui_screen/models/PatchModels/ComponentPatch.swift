//
//  ComponentPatch.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import Foundation

struct ComponentPatch {
    enum Method { case insert, update, delete }
    let parentPath: String
    let childId: String
    let method: Method
    let content: BduiComponentUiModel?
}

final class ComponentPatchGroup {
    var updates: [String: BduiComponentUiModel] = [:]
    var inserts: [(String, BduiComponentUiModel)] = []
    var deletes: Set<String> = []
}
