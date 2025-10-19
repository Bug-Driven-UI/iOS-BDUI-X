//
//  OverlayLoader.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

public struct OverlayLoader<Content: View>: View {
    let isLoading: Bool
    let shouldFillMaxSize: Bool
    let content: Content

    public init(
        isLoading: Bool,
        shouldFillMaxSize: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.isLoading = isLoading
        self.shouldFillMaxSize = shouldFillMaxSize
        self.content = content()
    }

    public var body: some View {
        let base = shouldFillMaxSize
            ? AnyView(content.frame(maxWidth: .infinity, maxHeight: .infinity))
            : AnyView(content)

        ZStack {
            base
            if isLoading {
                Color.white.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                BduiLoaderComponent()
                    .frame(width: 24, height: 24)
            }
        }
    }
}
