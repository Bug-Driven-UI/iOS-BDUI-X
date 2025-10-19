//
//  SnackbarHostState.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation
import Combine

public final class SnackbarHostState: ObservableObject {
    @Published public private(set) var current: SnackbarMessage?
    private var hideTask: Task<Void, Never>?

    public init() {}

    @MainActor
    public func showSnackbar(message: String, duration: SnackbarDuration) {
        hideTask?.cancel()
        current = SnackbarMessage(text: message, duration: duration)

        if let delay = duration.timeInterval {
            hideTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                await MainActor.run {
                    if !Task.isCancelled {
                        self?.current = nil
                    }
                }
            }
        }
    }

    @MainActor
    public func dismiss() {
        hideTask?.cancel()
        current = nil
    }
}
