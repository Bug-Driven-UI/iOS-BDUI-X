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
    let enableFade: Bool

    @State private var loaded = false

    public init(
        component: BduiImageComponentModel,
        enableFade: Bool = true
    ) {
        self.component = component
        self._loaded = State(initialValue: false)
        self.enableFade = enableFade
    }

    public var body: some View {
        GeometryReader { geo in
            let urlString = component.imageUrl.isEmpty
                ? "https://placekitten.com/800/400"
                : component.imageUrl

            let pixelSize = CGSize(
                width: max(1, geo.size.width * UIScreen.main.scale),
                height: max(1, geo.size.height * UIScreen.main.scale)
            )
            let processor = DownsamplingImageProcessor(size: pixelSize)

            KFImage(URL(string: urlString))
                .placeholder {
                    Rectangle().fill(Color.gray.opacity(0.1))
                }
                .setProcessor(processor)
                .cacheOriginalImage(false)
                .scaleFactor(UIScreen.main.scale)
                .fade(duration: enableFade ? 0.25 : 0.0)
                .onSuccess { _ in loaded = true }
                .onFailure { _ in loaded = true }
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped() // …and crop overflow
                .opacity(!enableFade || loaded ? 1.0 : 0.0)
                .animation(.easeInOut(duration: enableFade ? 0.25 : 0), value: loaded)
        }

    }
}
