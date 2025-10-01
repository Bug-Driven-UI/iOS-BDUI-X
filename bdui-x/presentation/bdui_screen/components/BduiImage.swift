//
//  BduiImage.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

import SwiftUI

struct BduiImage: View {
    let url: String
    @State private var fadedIn = false

    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                placeholder
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .opacity(fadedIn ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.35)) {
                            fadedIn = true
                        }
                    }
            case .failure:
                errorView
            @unknown default:
                placeholder
            }
        }
        .clipped()
    }

    private var placeholder: some View {
        Color.gray.opacity(0.2)
    }

    private var errorView: some View {
        Color.red.opacity(0.25)
    }
}
