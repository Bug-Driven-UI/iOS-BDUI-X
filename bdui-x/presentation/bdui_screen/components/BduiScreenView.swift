//
//  BduiScreenView.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import SwiftUI

struct BduiScreenView: View {
    let args: BduiScreenArgs

    var body: some View {
        VStack(spacing: 12) {
            Text("BduiScreen: \(args.screenId)")
                .font(.headline)
            Button("Назад") {
                NavigationManager.shared.back()
            }
        }
        .padding()
    }
}
