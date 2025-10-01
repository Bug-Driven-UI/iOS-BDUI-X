//
//  StartScreenView.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import SwiftUI

struct StartScreenView: View {
    @EnvironmentObject var nav: NavigationCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Start Screen")
            Button("Открыть экран") {
                let args = BduiScreenArgs(
                    screenId: "demo",
                    screenParams: [:]
                )
                NavigationManager.shared.navigate(.bduiScreen(args))
            }
            Button("Bottom Sheet") {
                let args = BduiBottomSheetArgs(
                    screenId: "sheet_demo",
                    screenParams: [:]
                )
                NavigationManager.shared.showSheet(.bdui(args))
            }
        }
        .padding()
    }
}
