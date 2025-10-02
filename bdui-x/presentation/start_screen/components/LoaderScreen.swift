//
//  LoaderScreen.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI


struct LoaderScreen: View {
    var body: some View {
        ZStack {
            Color.clear
            BduiLoaderView()
                .frame(width: 24, height: 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
