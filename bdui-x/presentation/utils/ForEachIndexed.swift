//
//  ForEachIndexed.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import SwiftUI

struct ForEachIndexed<Content: View>: View {
    let items: [BduiComponentUI]
    let builder: (BduiComponentUI) -> Content

    init(_ items: [BduiComponentUI],
         @ViewBuilder builder: @escaping (BduiComponentUI) -> Content) {
        self.items = items
        self.builder = builder
    }

    var body: some View {
        ForEach(Array(items.enumerated()), id: \.1.base.id) { _, element in
            builder(element)
        }
    }
}
