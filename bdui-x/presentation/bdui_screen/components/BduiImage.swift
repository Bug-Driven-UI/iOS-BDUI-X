//
//  BduiImage.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import Kingfisher
import SwiftUI

public struct BduiImageComponent: View {
    let component: BduiImageComponentModel
    let contentMode: SwiftUI.ContentMode
    let enableFade: Bool

    @State private var loaded = false

    public init(
        component: BduiImageComponentModel,
        contentMode: SwiftUI.ContentMode = .fill,
        enableFade: Bool = true
    ) {
        self.component = component
        self.contentMode = contentMode
        self._loaded = State(initialValue: false)
        self.enableFade = enableFade
    }

    public var body: some View {
        let urlString = component.imageUrl.isEmpty ? "https://placekitten.com/800/400" : component.imageUrl

        KFImage(URL(string: urlString))
            .placeholder {
                Rectangle().fill(Color.gray.opacity(0.1))
            }
            .fade(duration: enableFade ? 0.35 : 0.0)
            .onSuccess { _ in loaded = true }
            .onFailure { _ in loaded = true }
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .opacity(!enableFade || loaded ? 1.0 : 0.0)
            .animation(.easeInOut(duration: enableFade ? 0.35 : 0), value: loaded)

    }
}
