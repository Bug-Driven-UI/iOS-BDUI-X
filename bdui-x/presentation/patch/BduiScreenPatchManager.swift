//
//  BduiScreenPatchManager.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

public final class BduiScreenPatchManager {
    public init() {}

    // Entry point: apply patches to root-level children list
    public func applyPatchesToRoot(
        rootChildren: [BduiComponentUiModel],
        patches: [ComponentPatchModel]
    ) -> [BduiComponentUiModel] {
        guard !patches.isEmpty else { return rootChildren }
        let patchGroups = groupPatchesByParent(patches: patches)
        let prefixSet = buildPrefixSet(patches: patches)

        return applyPatchesToChildren(
            currentPath: PATH_ROOT,
            children: rootChildren,
            patchGroups: patchGroups,
            prefixSet: prefixSet
        )
    }

    // MARK: - Core recursion

    private func applyPatchesToChildren(
        currentPath: String,
        children: [BduiComponentUiModel],
        patchGroups: [String: ComponentPatchGroupModel],
        prefixSet: Set<String>
    ) -> [BduiComponentUiModel] {
        guard prefixSet.contains(currentPath) else { return children }

        let patchGroup = patchGroups[currentPath]
        let hasLocalOps = (patchGroup?.updates.isEmpty == false)
            || (patchGroup?.inserts.isEmpty == false)
            || (patchGroup?.deletes.isEmpty == false)

        var result: [BduiComponentUiModel] = []
        result.reserveCapacity(children.count + (patchGroup?.inserts.count ?? 0))

        
        if let inserts = patchGroup?.inserts, !inserts.isEmpty {
            for (_, newComponent) in inserts {
                result.append(newComponent)
            }
        }

        for child in children {
            let childId = child.baseId
            // Delete filter
            if let deletes = patchGroup?.deletes, deletes.contains(childId) {
                continue
            }

            // Update by id if present
            if let updated = patchGroup?.updates[childId] {
                result.append(updated)
                continue
            }

            // Recurse into containers
            if let containerChildren = child.containerChildren {
                let childPath = joinPath(parentPath: currentPath, childId: childId)
                let patchedChildren = applyPatchesToChildren(
                    currentPath: childPath,
                    children: containerChildren,
                    patchGroups: patchGroups,
                    prefixSet: prefixSet
                )
                if patchedChildren == containerChildren {
                    result.append(child)
                } else if let replaced = child.replacingChildren(patchedChildren) {
                    result.append(replaced)
                } else {
                    // Non-container or failed replacement (shouldn't happen)
                    result.append(child)
                }
            } else {
                // Leaf unchanged
                result.append(child)
            }
        }

        // Early return if nothing changed locally and structure identical
        if !hasLocalOps, result.count == children.count, result == children {
            return children
        }
        return result
    }

    // MARK: - Grouping and prefix building

    private func groupPatchesByParent(patches: [ComponentPatchModel]) -> [String: ComponentPatchGroupModel] {
        var groups: [String: ComponentPatchGroupModel] = [:]
        for patch in patches {
            var group = groups[patch.parentPath] ?? ComponentPatchGroupModel()
            switch patch.method {
            case .insert:
                if let content = patch.content {
                    group.inserts.append((patch.childId, content))
                }
            case .update:
                if let content = patch.content {
                    group.updates[patch.childId] = content
                }
            case .delete:
                group.deletes.insert(patch.childId)
            }
            groups[patch.parentPath] = group
        }
        return groups
    }

    private func buildPrefixSet(patches: [ComponentPatchModel]) -> Set<String> {
        var prefixSet: Set<String> = [PATH_ROOT]
        for patch in patches {
            var path = patch.parentPath
            if path.hasSuffix(PATH_SEPARATOR) {
                path.removeLast()
            }
            if path.isEmpty { path = PATH_ROOT }

            let segments = path.pathToSegments()
            for i in segments.indices {
                let prefix = PATH_ROOT + segments.prefix(i + 1).joined(separator: PATH_SEPARATOR)
                prefixSet.insert(prefix)
            }
        }
        return prefixSet
    }

    // MARK: - Helpers

    private func joinPath(parentPath: String, childId: String) -> String {
        if parentPath == PATH_ROOT { return "\(PATH_ROOT)\(childId)" }
        return "\(parentPath)\(PATH_SEPARATOR)\(childId)"
    }
}

// MARK: - BduiComponentUiModel helpers

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

    var containerChildren: [BduiComponentUiModel]? {
        switch self {
        case .rowModel(let m): return m.children
        case .columnModel(let m): return m.children
        case .boxModel(let m): return m.children
        default: return nil
        }
    }

    func replacingChildren(_ newChildren: [BduiComponentUiModel]) -> BduiComponentUiModel? {
        switch self {
        case .rowModel(let m):
            return .rowModel(BduiRowComponentModel(
                horizontalArrangement: m.horizontalArrangement,
                verticalAlignment: m.verticalAlignment,
                isScrollable: m.isScrollable,
                baseProperties: m.baseProperties,
                children: newChildren
            ))
        case .columnModel(let m):
            return .columnModel(BduiColumnComponentModel(
                verticalArrangement: m.verticalArrangement,
                horizontalAlignment: m.horizontalAlignment,
                baseProperties: m.baseProperties,
                children: newChildren
            ))
        case .boxModel(let m):
            return .boxModel(BduiBoxComponentModel(
                contentAlignment: m.contentAlignment,
                baseProperties: m.baseProperties,
                children: newChildren
            ))
        default:
            return nil
        }
    }
}
