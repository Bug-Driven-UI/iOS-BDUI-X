//
//  BduiScreenViewModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

@MainActor
final class BduiScreenViewModel: ObservableObject {
    @Published private(set) var uiState: UiState<RenderedScreenUi> = .loading

    private let screenName: String
    private let screenParams: [String: JSONValue]?
    private let interactor: BduiInteractor
    private let screenFactory: BduiScreenFactory
    private let hashCollector: BduiScreenHashCollector
    private let navigation: NavigationManager
    private let snackbar: SnackbarManager

    private var screenLoadTask: Task<Void, Never>?
    private var actionTask: Task<Void, Never>?

    init(
        screenName: String,
        screenParams: [String: JSONValue]?,
        interactor: BduiInteractor,
        screenFactory: BduiScreenFactory,
        hashCollector: BduiScreenHashCollector,
        navigation: NavigationManager,
        snackbar: SnackbarManager,
    ) {
        self.screenName = screenName
        self.screenParams = screenParams
        self.interactor = interactor
        self.screenFactory = screenFactory
        self.hashCollector = hashCollector
        self.navigation = navigation
        self.snackbar = snackbar

        startCollect()
    }

    deinit {
        screenLoadTask?.cancel()
        actionTask?.cancel()
    }

    // MARK: - Public API

    func retry() {
        startCollect(forceReload: true)
    }

    func onAction(_ action: BduiActionUI) {
        switch action {
        case .navigateBack:
            navigation.back()
        case .retry:
            retry()
        case .navigateTo(let screen, let params):
            navigation.navigate(.bduiScreen(.init(screenId: screen, screenParams: params ?? [String: JSONValue]())))
        case .sendRemoteActions(let remotes):
            performRemoteActions(remotes)
        }
    }

    // MARK: - Screen Loading

    private func startCollect(forceReload: Bool = false) {
        if forceReload {
            screenLoadTask?.cancel()
        }
        screenLoadTask = Task {
            uiState = .loading
            let request = ScreenRenderRequestModel(
                data: .init(screenName: screenName, variables: screenParams)
            )
            do {
                for try await state in interactor.getScreen(request: request) {
                    switch state {
                    case .loading:
                        uiState = .loading
                    case .success(let model):
                        let ui = screenFactory.create(screen: model)
                        uiState = .content(ui)
                    case .error:
                        uiState = .error
                    }
                }
            } catch {
                uiState = .error
            }
        }
    }

    // MARK: - Remote Actions

    private func performRemoteActions(_ actions: [BduiActionUI.Remote]) {
        guard case .content(let current) = uiState else { return }

        actionTask?.cancel()
        actionTask = Task {
            uiState.updateContent { $0.withLoading(true) }

            let request = ScreenDoActionRequestModel(
                actions: actions.map { remote in
                    switch remote {
                    case .command(let name, let params):
                        return .command(.init(name: name, params: params))
                    case .updateScreen(let name, let params):
                        let hashes = hashCollector.collect(componentTree: current.components)
                        return .updateScreen(.init(screenName: name, hashes: hashes, screenNavigationParams: params))
                    }
                }
            )

            do {
                for try await op in interactor.doActions(request: request) {
                    switch op {
                    case .loading:
                        // Already set loading; keep it
                        continue
                    case .error:
                        uiState.updateContent { $0.withLoading(false) }
                        snackbar.show(text: "Error happened")
                    case .success(let aggregate):
                        handleActionResponses(aggregate.responses)
                    }
                }
            } catch {
                uiState.updateContent { $0.withLoading(false) }
                snackbar.show(text: "Error happened!")
            }
        }
    }

    private func handleActionResponses(_ responses: [ActionResponseModel]) {
        for response in responses {
            switch response {
            case .command(let cmd):
                handleCommandResponse(cmd.response)
            case .updateScreen(let upd):
                handleUpdateScreenResponse(upd.response)
            }
        }
    }

    private func handleCommandResponse(_ response: ActionResponseModel.Command.Response) {
        uiState.updateContent { $0.withLoading(false) }
        if let fallback = response.data.fallbackMessage {
            snackbar.show(text: fallback)
        }
    }

    private func handleUpdateScreenResponse(_ response: ActionResponseModel.UpdateScreen.Response) {
        guard case .content(let existing) = uiState else { return }

        let patched = screenFactory.createPatchedScreen(
            screen: existing,
            updateScreenResponse: response
        )
        uiState = .content(patched)
    }
}
