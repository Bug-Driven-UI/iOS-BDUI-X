//
//  LoaderScreen.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

public struct LoaderScreen: View {
    public var body: some View {
        ZStack {
            Color.clear
            BduiLoaderComponent()
                .frame(width: 24, height: 24)
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
