//
//  SnackbarBridgeModifier.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import SwiftUI
import Combine

public struct SnackbarBridgeModifier: ViewModifier {
    let manager: SnackbarManager
    @StateObject private var hostState = SnackbarHostState()
    @State private var cancellable: AnyCancellable?

    public init(manager: SnackbarManager) {
        self.manager = manager
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            AppSnackbarHost(hostState: hostState)
        }
        .onAppear {
            if cancellable == nil {
                cancellable = manager.messages
                    .receive(on: DispatchQueue.main)
                    .sink { msg in
                        hostState.showSnackbar(message: msg.text, duration: msg.duration)
                    }
            }
        }
        .onDisappear {
        }
    }
}

public extension View {
    func rememberAppSnackbarHostState(snackbarManager: SnackbarManager) -> some View {
        self.modifier(SnackbarBridgeModifier(manager: snackbarManager))
    }
}
