//
//  SnackbarManager.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation
import Combine

public final class SnackbarManager {
    public let messages = PassthroughSubject<SnackbarMessage, Never>()

    public init() {}

    public func show(text: String, duration: SnackbarDuration = .short) {
        messages.send(SnackbarMessage(text: text, duration: duration))
    }
}