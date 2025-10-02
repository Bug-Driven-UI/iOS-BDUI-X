//
//  State.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum UiState<Content> {
    case loading
    case error
    case content(Content)
}

extension UiState {
    var content: Content? {
        if case .content(let c) = self { return c } else { return nil }
    }

    mutating func updateContent(_ transform: (Content) -> Content) {
        guard case .content(let c) = self else { return }
        self = .content(transform(c))
    }
}

enum OperationState<T> {
    case loading
    case success(T)
    case error(Error)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
