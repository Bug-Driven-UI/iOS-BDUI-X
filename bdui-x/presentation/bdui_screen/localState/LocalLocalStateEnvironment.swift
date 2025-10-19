//
//  LocalLocalStatesKey.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Combine
import SwiftUI

private struct LocalLocalStatesKey: EnvironmentKey {
    static let defaultValue: LocalStateStore? = nil
}

public extension EnvironmentValues {
    var localLocalStates: LocalStateStore? {
        get { self[LocalLocalStatesKey.self] }
        set { self[LocalLocalStatesKey.self] = newValue }
    }
}

public extension View {
    func provideLocalStates(_ store: LocalStateStore) -> some View {
        environment(\.localLocalStates, store)
    }
}

public extension LocalStateStore {
    func stringPublisher(for path: Path, initialValue: String = "") -> AnyPublisher<String, Never> {
        localStatesPublisher
            .map { $0[path] ?? initialValue }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

public struct LocalStateValueReader<Content: View>: View {
    @Environment(\.localLocalStates) private var store

    private let path: Path
    private let initialValue: String
    private let content: (String) -> Content

    @State private var value: String
    @State private var cancellable: AnyCancellable?

    public init(
        path: Path,
        initialValue: String = "",
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self.path = path
        self.initialValue = initialValue
        self.content = content
        _value = State(initialValue: initialValue)
    }

    public var body: some View {
        content(value)
            .onAppear {
                guard let store else {
                    fatalError("LocalLocalStates is not provided")
                }
                if cancellable == nil {
                    cancellable = store
                        .stringPublisher(for: path, initialValue: initialValue)
                        .receive(on: DispatchQueue.main)
                        .sink { v in value = v }
                }
            }
            .onDisappear {
                // Optional: keep subscription alive across appearances if desired.
                // If you prefer to release immediately:
                // cancellable?.cancel()
                // cancellable = nil
            }
    }
}

// Resolves either a literal string or subscribes to a local state path.
// Crashes if a local-state reference is used without a provided store.
public struct RememberTextOrLocalState<Content: View>: View {
    @Environment(\.localLocalStates) private var store

    private let source: TextOrLocalStateModel
    private let content: (String) -> Content

    @State private var value: String
    @State private var cancellable: AnyCancellable?

    public init(
        _ source: TextOrLocalStateModel,
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self.source = source
        switch source {
        case .text(let s): _value = State(initialValue: s)
        case .localState:  _value = State(initialValue: "")
        }
        self.content = content
    }

    public var body: some View {
        content(value)
            .onAppear {
                switch source {
                case .text(let s):
                    value = s
                    cancellable = nil
                case .localState(let path):
                    guard let store else {
                        fatalError("LocalLocalStates is not provided")
                    }
                    if cancellable == nil {
                        cancellable = store
                            .stringPublisher(for: path, initialValue: "")
                            .receive(on: DispatchQueue.main)
                            .sink { v in value = v }
                    }
                }
            }
            .onDisappear {

            }
    }
}
