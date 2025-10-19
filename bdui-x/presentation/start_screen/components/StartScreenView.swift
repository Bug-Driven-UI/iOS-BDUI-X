//
//  StartScreenView.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import SwiftUI

@MainActor
final class StartScreenViewModel: ObservableObject {
    @Published private(set) var uiState: UiStateModel<Void> = .loading

    private let navigation: NavigationManager
    private let startScreenName = "startScreen"

    init(navigation: NavigationManager) {
        self.navigation = navigation
        Task { await boot() }
    }

    private func boot() async {
        try? await Task.sleep(nanoseconds: 700_000_000)
        loadInitialBduiScreen()
    }

    private func loadInitialBduiScreen() {
        let args = BduiScreenArgs(screenName: startScreenName, screenParams: nil)
        navigation.replace(.bduiScreen(args))
    }
}

struct StartScreenView: View {
    @Environment(\.bduiColors) private var colors
    @Environment(\.bduiTypography) private var typography

    @StateObject private var viewModel: StartScreenViewModel

    init(navigation: NavigationManager) {
        _viewModel = StateObject(wrappedValue: StartScreenViewModel(navigation: navigation))
    }

    var body: some View {
        LoaderScreen()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea(.container, edges: [.top, .bottom])
    }
}
