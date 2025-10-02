//
//  BduiScreenPatchFactory.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//
import Foundation

final class BduiScreenPatchFactory {
    func createPatches(
        updates: [ActionResponseModel.UpdateScreen.Response.Data],
        factory: (RenderedComponent) -> BduiComponentUI
    ) -> [ComponentPatch] {
        updates.compactMap { update in
            let segments = update.target.pathToSegments()
            guard !segments.isEmpty else { return nil }

            let parentPath: String =
                (segments.count == 1)
            ? PresentationConstants.PATH_ROOT
            : PresentationConstants.PATH_ROOT + segments.dropLast(1).joined(separator: PresentationConstants.PATH_SEPARATOR)

            let childId = segments.last!

            let method: ComponentPatch.Method
            switch update.method {
            case .insert: method = .insert
            case .update: method = .update
            case .delete: method = .delete
            }

            return ComponentPatch(
                parentPath: parentPath,
                childId: childId,
                method: method,
                content: update.content.map(factory)
            )
        }
    }
}
public extension String {
    func pathToSegments() -> [String] {
        trimmingCharacters(in: CharacterSet(charactersIn: PresentationConstants.PATH_SEPARATOR))
            .split(separator: PresentationConstants.PATH_SEPARATOR_CHAR)
            .map(String.init)
            .filter { !$0.isEmpty }
    }
}
