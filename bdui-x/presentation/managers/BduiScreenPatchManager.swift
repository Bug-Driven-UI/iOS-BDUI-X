//
//  BduiScreenPatchManager.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import Foundation

import Foundation

final class BduiScreenPatchManager {
    func applyPatchesToRoot(
        rootChildren: [BduiComponentUI],
        patches: [ComponentPatch]
    ) -> [BduiComponentUI] {
        guard !patches.isEmpty else { return rootChildren }

        let patchGroups = groupPatchesByParent(patches)
        let prefixSet = buildPrefixSet(patches)

        return applyPatchesToChildren(
            currentPath: PresentationConstants.PATH_ROOT,
            children: rootChildren,
            patchGroups: patchGroups,
            prefixSet: prefixSet
        )
    }

    // MARK: - Recursive Application

    private func applyPatchesToChildren(
        currentPath: String,
        children: [BduiComponentUI],
        patchGroups: [String: ComponentPatchGroup],
        prefixSet: Set<String>
    ) -> [BduiComponentUI] {
        
        guard prefixSet.contains(currentPath) else { return children }

        let patchGroup = patchGroups[currentPath]
        let hasLocalOps = patchGroup.map { !$0.updates.isEmpty || !$0.inserts.isEmpty || !$0.deletes.isEmpty } ?? false

        var result: [BduiComponentUI] = []
        result.reserveCapacity(children.count + (patchGroup?.inserts.count ?? 0))

        
        if let inserts = patchGroup?.inserts, !inserts.isEmpty {
            
            for (_, inserted) in inserts {
                result.append(inserted)
            }
        }

        
        for child in children {
            let childId = child.base.id

            
            if patchGroup?.deletes.contains(childId) == true {
                continue
            }

            if let updated = patchGroup?.updates[childId] {
                result.append(updated)
                continue
            }

            if let containerReplacement = patchContainerIfNeeded(
                parentPath: currentPath,
                child: child,
                patchGroups: patchGroups,
                prefixSet: prefixSet
            ) {
                result.append(containerReplacement)
            } else {
                result.append(child)
            }
        }

        if !hasLocalOps,
           result.count == children.count,
           result.elementsEqual(children, by: { $0.base.id == $1.base.id && $0.base.hash == $1.base.hash })
        {
            return children
        }

        return result
    }

    private func patchContainerIfNeeded(
        parentPath: String,
        child: BduiComponentUI,
        patchGroups: [String: ComponentPatchGroup],
        prefixSet: Set<String>
    ) -> BduiComponentUI? {
        switch child {
        case .column(let base, let kids):
            let path = joinPath(parentPath: parentPath, childId: base.id)
            let patchedKids = applyPatchesToChildren(
                currentPath: path,
                children: kids,
                patchGroups: patchGroups,
                prefixSet: prefixSet
            )
            return (patchedKids == kids) ? nil : .column(base: base, children: patchedKids)

        case .row(let base, let kids):
            let path = joinPath(parentPath: parentPath, childId: base.id)
            let patchedKids = applyPatchesToChildren(
                currentPath: path,
                children: kids,
                patchGroups: patchGroups,
                prefixSet: prefixSet
            )
            return (patchedKids == kids) ? nil : .row(base: base, children: patchedKids)

        case .box(let base, let kids):
            let path = joinPath(parentPath: parentPath, childId: base.id)
            let patchedKids = applyPatchesToChildren(
                currentPath: path,
                children: kids,
                patchGroups: patchGroups,
                prefixSet: prefixSet
            )
            return (patchedKids == kids) ? nil : .box(base: base, children: patchedKids)

        default:
            return nil
        }
    }

    // MARK: - Patch Grouping

    private func groupPatchesByParent(_ patches: [ComponentPatch]) -> [String: ComponentPatchGroup] {
        var groups: [String: ComponentPatchGroup] = [:]
        for patch in patches {
            let group = groups[patch.parentPath, default: ComponentPatchGroup()]
            switch patch.method {
            case .insert:
                if let c = patch.content {
                    group.inserts.append((patch.childId, c))
                }
            case .update:
                if let c = patch.content {
                    group.updates[patch.childId] = c
                }
            case .delete:
                group.deletes.insert(patch.childId)
            }
            groups[patch.parentPath] = group
        }
        return groups
    }

    // MARK: - Prefix Set (optimization to skip entire branches quickly)

    private func buildPrefixSet(_ patches: [ComponentPatch]) -> Set<String> {
        var set: Set<String> = [PresentationConstants.PATH_ROOT]
        for patch in patches {
            var parent = patch.parentPath
                .trimmingCharacters(in: CharacterSet(charactersIn: String(PresentationConstants.PATH_SEPARATOR_CHAR)))
            if parent.isEmpty {
                parent = PresentationConstants.PATH_ROOT
            }
            let segments = parent.pathToSegments()
            for idx in segments.indices {
                let prefix = PresentationConstants.PATH_ROOT +
                    segments.prefix(idx + 1).joined(separator: PresentationConstants.PATH_SEPARATOR)
                set.insert(prefix)
            }
        }
        return set
    }

    // MARK: - Path Join

    private func joinPath(parentPath: String, childId: String) -> String {
        parentPath == PresentationConstants.PATH_ROOT
            ? "\(PresentationConstants.PATH_ROOT)\(childId)"
            : "\(parentPath)\(PresentationConstants.PATH_SEPARATOR)\(childId)"
    }
}
