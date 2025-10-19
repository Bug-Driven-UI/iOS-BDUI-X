//
//  LocalStateStore.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Combine
import Foundation

public typealias Path = String
public typealias LocalStates = [Path: String]


@MainActor
public final class LocalStateStore: ObservableObject {
    @Published private var _localStates: LocalStates = [:]

    public var localStatesPublisher: AnyPublisher<LocalStates, Never> {
        $_localStates.eraseToAnyPublisher()
    }

    public var localStates: LocalStates { _localStates }

    public init() {}

    public func get(_ path: Path) -> String? {
        _localStates[path]
    }

    public func set(_ path: Path, value: String) {
        _localStates[path] = value
    }

    public func setJSON(_ path: Path, value: JSONValue) {
        _localStates[path] = Self.string(from: value) ?? ""
    }

    public func setAll(rawStates: [Path: JSONValue]) {
        _localStates = Self.flatten(rawStates: rawStates)
    }

    public func clear() {
        _localStates = [:]
    }

    // MARK: - Helpers

    private static func flatten(
        rawStates: [Path: JSONValue],
        parentKey: String? = nil
    ) -> [Path: String] {
        var states: [Path: String] = [:]
        for (key, value) in rawStates {
            let fullKey = (parentKey != nil) ? "\(parentKey!).\(key)" : key
            switch value {
            case .object(let obj):
                let nested = flatten(rawStates: obj, parentKey: fullKey)
                for (k, v) in nested {
                    states[k] = v
                }
            case .array:
                continue
            default:
                states[fullKey] = string(from: value) ?? ""
            }
        }
        return states
    }

    private static func string(from value: JSONValue) -> String? {
        switch value {
        case .string(let s): return s
        case .number(let n):
            if floor(n) == n { return String(Int(n)) }
            return String(n)
        case .bool(let b): return b ? "true" : "false"
        case .object, .array, .null:
            return nil
        }
    }
}
