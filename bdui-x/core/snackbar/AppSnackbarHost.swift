//
//  AppSnackbarHost.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import SwiftUI
import Combine

public struct AppSnackbarHost: View {
    @ObservedObject var hostState: SnackbarHostState

    // Styling hooks
    public var containerColor: Color = Color.black.opacity(0.86)
    public var contentColor: Color = Color.white
    public var cornerRadius: CGFloat = 28
    public var horizontalPadding: CGFloat = 8
    public var textHorizontalPadding: CGFloat = 20
    public var textVerticalPadding: CGFloat = 16
    public var bottomSpacer: CGFloat = 112

    public init(hostState: SnackbarHostState) {
        self.hostState = hostState
    }

    public var body: some View {
        VStack {
            Spacer(minLength: 0)
            if let message = hostState.current {
                VStack(spacing: 0) {
                    HStack {
                        Text(message.text)
                            .foregroundColor(contentColor)
                            .padding(.horizontal, textHorizontalPadding)
                            .padding(.vertical, textVerticalPadding)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(containerColor)
                    )
                    .padding(.horizontal, horizontalPadding)

                    Spacer().frame(height: bottomSpacer)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.35, dampingFraction: 0.9), value: hostState.current)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding(.bottom, 0)
    }
}
