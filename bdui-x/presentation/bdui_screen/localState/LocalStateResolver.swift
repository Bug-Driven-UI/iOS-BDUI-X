//
//  LocalStateResolver.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public final class LocalStateResolver {
    private static let prefix = "#{localStates."
    private static let suffix = "}"

    private let localStateStore: LocalStateStore

    public init(localStateStore: LocalStateStore) {
        self.localStateStore = localStateStore
    }

    public func resolveRawPath(_ rawPath: String) -> Path? {
        guard rawPath.hasPrefix(Self.prefix), rawPath.hasSuffix(Self.suffix) else { return nil }
        let start = rawPath.index(rawPath.startIndex, offsetBy: Self.prefix.count)
        let end = rawPath.index(before: rawPath.endIndex)
        return String(rawPath[start..<end])
    }

    @MainActor
    public func resolveLocalStateRefs(_ json: JSONValue) -> JSONValue {
        switch json {
        case .string(let s):
            guard let path = resolveRawPath(s) else { return .string(s) }
            if let stored = localStateStore.get(path) {
                return Self.stringToJSONValue(stored)
            } else {
                return .string(s)
            }

        case .number, .bool, .null:
            return json

        case .object(let obj):
            var out: [String: JSONValue] = [:]
            out.reserveCapacity(obj.count)
            for (k, v) in obj {
                out[k] = resolveLocalStateRefs(v)
            }
            return .object(out)

        case .array(let arr):
            return .array(arr.map(resolveLocalStateRefs(_:)))
        }
    }

    public func resolveLocalStateRefsAsync(_ json: JSONValue) async -> JSONValue {
        await MainActor.run { resolveLocalStateRefs(json) }
    }

    private static func stringToJSONValue(_ s: String) -> JSONValue {
        let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()
        if lower == "true" { return .bool(true) }
        if lower == "false" { return .bool(false) }
        if let n = Double(trimmed) { return .number(n) }
        return .string(s)
    }
}
