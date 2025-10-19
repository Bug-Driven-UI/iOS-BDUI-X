//
//  PatchModels.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public let PATH_ROOT: String = "/"
public let PATH_SEPARATOR: String = "/"
public let PATH_SEPARATOR_CHAR: Character = "/"

public extension String {
    func pathToSegments() -> [String] {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return trimmed.split(separator: PATH_SEPARATOR_CHAR).map { String($0) }.filter { !$0.isEmpty }
    }
}

// MARK: - Update payload coming from API mapping (Swift-side model of Android PatchData)

public struct UpdateScreenPatchDataModel: Equatable, Codable {
    public enum ActionMethodModel: String, Codable {
        case insert = "INSERT"
        case update = "UPDATE"
        case delete = "DELETE"
    }

    public let target: String
    public let method: ActionMethodModel
    public let content: RenderedComponentModel?

    public init(target: String, method: ActionMethodModel, content: RenderedComponentModel?) {
        self.target = target
        self.method = method
        self.content = content
    }
}

// MARK: - Patch models (Swift)

public struct ComponentPatchModel: Equatable {
    public enum Method: String, Equatable { case insert = "INSERT", update = "UPDATE", delete = "DELETE" }

    public let parentPath: String
    public let childId: String
    public let method: Method
    public let content: BduiComponentUiModel?

    public init(parentPath: String, childId: String, method: Method, content: BduiComponentUiModel?) {
        self.parentPath = parentPath
        self.childId = childId
        self.method = method
        self.content = content
    }
}


public struct ComponentPatchGroupModel {
    public var updates: [String: BduiComponentUiModel]
    public var inserts: [(String, BduiComponentUiModel)]
    public var deletes: Set<String>

    public init(
        updates: [String: BduiComponentUiModel] = [:],
        inserts: [(String, BduiComponentUiModel)] = [],
        deletes: Set<String> = []
    ) {
        self.updates = updates
        self.inserts = inserts
        self.deletes = deletes
    }
}

extension ComponentPatchGroupModel: Equatable {
    public static func == (lhs: ComponentPatchGroupModel, rhs: ComponentPatchGroupModel) -> Bool {
        lhs.updates == rhs.updates &&
        lhs.inserts.elementsEqual(rhs.inserts, by: { $0.0 == $1.0 && $0.1 == $1.1 }) &&
        lhs.deletes == rhs.deletes
    }
}
