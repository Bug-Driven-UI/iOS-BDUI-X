//
//  bdui_xApp.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import SwiftUI


@main
struct bdui_xApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let dependencies: AppDependencies = .makeProduction()

    var body: some Scene {
        WindowGroup {
            BduiTheme {
                BduiNavGraph(
                    navigationManager: dependencies.navigationManager,
                    resultStore: dependencies.navigationResults,
                    start: {
                        StartScreenView(navigation: dependencies.navigationManager)
                    },
                    bduiScreen: { args, isBottomSheet in
                        BduiScreenView(
                            args: args,
                            isBottomSheet: isBottomSheet,
                            dependencies: dependencies
                        )
                    }
                )
            }
        }
    }
}
