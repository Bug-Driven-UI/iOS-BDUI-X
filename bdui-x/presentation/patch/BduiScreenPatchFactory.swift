//
//  BduiScreenPatchFactory.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public final class BduiScreenPatchFactory {
    public init() {}

    
    public func createPatches(
        updates: [UpdateScreenPatchDataModel],
        factory: (RenderedComponentModel) -> BduiComponentUiModel
    ) -> [ComponentPatchModel] {
        updates.compactMap { update in
            let segments = update.target.pathToSegments()
            guard !segments.isEmpty else { return nil }

            let parentPath: String
            if segments.count == 1 {
                parentPath = PATH_ROOT
            } else {
                parentPath = PATH_ROOT + segments.dropLast().joined(separator: PATH_SEPARATOR)
            }

            let childId = segments.last!
            let method: ComponentPatchModel.Method
            switch update.method {
            case .insert: method = .insert
            case .update: method = .update
            case .delete: method = .delete
            }

            let content = update.content.map(factory)

            return ComponentPatchModel(
                parentPath: parentPath,
                childId: childId,
                method: method,
                content: content
            )
        }
    }
}
