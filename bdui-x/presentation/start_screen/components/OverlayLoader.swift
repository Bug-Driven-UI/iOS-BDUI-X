//
//  OverlayLoader.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

struct OverlayLoader<Content: View>: View {
    let isLoading: Bool
    let content: () -> Content

    init(isLoading: Bool,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.isLoading = isLoading
        self.content = content
    }

    var body: some View {
        ZStack {
            content()
            if isLoading {
                Color.clear
                    .overlay(
                        Color.gray.opacity(0.5)
                            .transition(.opacity)
                    )
                    .overlay(
                        BduiLoaderView(color: .black, strokeWidth: 3)
                            .frame(width: 24, height: 24)
                            .transition(.opacity)
                    )
                    .animation(.easeInOut(duration: 0.25), value: isLoading)
            }
        }
    }
}
