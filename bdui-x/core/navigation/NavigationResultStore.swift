//
//  NavigationResultStore.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation
import Combine

public final class NavigationResultStore: ObservableObject {
    @Published private var store: [String: JSONValue] = [:]

    public init() {}

    public func set(_ key: String, value: JSONValue) {
        store[key] = value
    }

    public func consume(_ key: String) -> JSONValue? {
        defer { store.removeValue(forKey: key) }
        return store[key]
    }

    public func publisher(for key: String) -> AnyPublisher<JSONValue, Never> {
        $store
            .compactMap { $0[key] }
            .eraseToAnyPublisher()
    }
}
