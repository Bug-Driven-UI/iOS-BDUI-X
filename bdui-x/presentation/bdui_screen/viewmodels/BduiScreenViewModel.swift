//
//  BduiScreenViewModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Combine
import Foundation

@MainActor
public final class BduiScreenViewModel: ObservableObject {

    // Inputs
    private let screenName: String
    private let screenParams: [String: JSONValue]?

    // Dependencies (actual types)
    private let interactor: IBduiInteractor
    private let screenFactory: BduiScreenFactory
    private let hashCollector: BduiScreenHashCollector
    private let navigation: NavigationManager
    private let snackbar: SnackbarManager
    private let resources: IResourcesWrapper
    private let analytics: IAnalyticsLoggerFacade
    public let localStateStore: LocalStateStore
    private let localStateResolver: LocalStateResolver

    // State
    @Published public private(set) var uiState: UiStateModel<RenderedScreenUiModel> = .loading

    private var cancellables = Set<AnyCancellable>()
    private let refreshTrigger = PassthroughSubject<Void, Never>()
    private var screenTask: Task<Void, Never>?
    private var remoteCommandsTask: Task<Void, Never>?

    public init(
        screenName: String,
        screenParams: [String: JSONValue]?,
        interactor: IBduiInteractor,
        screenFactory: BduiScreenFactory,
        hashCollector: BduiScreenHashCollector,
        navigation: NavigationManager,
        snackbar: SnackbarManager,
        resources: IResourcesWrapper,
        analytics: IAnalyticsLoggerFacade,
        localStateStore: LocalStateStore,
        localStateResolver: LocalStateResolver
    ) {
        self.screenName = screenName
        self.screenParams = screenParams
        self.interactor = interactor
        self.screenFactory = screenFactory
        self.hashCollector = hashCollector
        self.navigation = navigation
        self.snackbar = snackbar
        self.resources = resources
        self.analytics = analytics
        self.localStateStore = localStateStore
        self.localStateResolver = localStateResolver

        startCollectFlow()
        refreshTrigger.send(())
    }

    public var uiStateContent: RenderedScreenUiModel {
        switch uiState {
        case .content(let c): return c
        default: return RenderedScreenUiModel(screenName: screenName, version: 0, components: [], scaffold: nil, isLoading: false)
        }
    }

    // MARK: - Actions

    public func onAction(_ action: BduiActionUiModel) {
        switch action {
        case .navigateBack(let model):
            onNavigateBack(updatePreviousScreen: model.updatePreviousScreen)

        case .sendRemoteActions(let actions):
            onRemoteActions(actions.actions)

        case .retry:
            onRetry()

        case .navigateTo(let nav):
            onNavigateTo(
                screenName: nav.screenName,
                screenNavigationParams: nav.screenNavigationParams,
                toBottomSheet: nav.toBottomSheet
            )

        case .componentClicked(let model):
            analytics.logComponentClicked(screenName: screenName, componentId: model.componentId)

        case .screenShown:
            analytics.logScreenShown(screenName: screenName)

        case .errorScreenShown:
            analytics.logErrorScreenShown(screenName: screenName)

        case .screenRendered(let r):
            analytics.logScreenRendered(
                screenName: screenName,
                screenVersion: r.screenVersion,
                componentsCount: r.components.count,
                renderTimeMs: r.renderTimeMs
            )

        case .inputValueChanged(let change):
            onInputValueChanged(actions: change.actions, newInputValue: change.newInputValue)

        case .setLocalState(let set):
            onSetLocalState(path: set.targetPath.value, newValue: set.newValue)

        case .updateScreenResultReceived:
            onUpdateScreenResultReceived()
        }
    }

    // MARK: - Flow (AsyncStream-based)

    private func startCollectFlow() {
        let request = ScreenRenderRequestModel(
            data: .init(screenName: screenName, variables: screenParams ?? [:])
        )

        refreshTrigger
            .sink { [weak self] in
                self?.launchScreenRequest(request: request)
            }
            .store(in: &cancellables)
    }

    private func launchScreenRequest(request: ScreenRenderRequestModel) {
        screenTask?.cancel()
        screenTask = Task { [weak self] in
            guard let self else { return }
            for await state in interactor.getScreen(request: request) {
                switch state {
                case .loading:
                    self.uiState = .loading
                case .error:
                    self.uiState = .error
                    self.localStateStore.clear()
                case .success(let response):
                    self.initializeLocalStateStore(screen: response.screen)
                    self.uiState = .content(self.screenFactory.create(screen: response.screen))
                }
            }
        }
    }

    private func initializeLocalStateStore(screen: RenderedScreenModel) {
        localStateStore.setAll(rawStates: screen.localStates ?? [:])
    }

    // MARK: - Remote actions (AsyncStream-based)

    private func onRemoteActions(_ actions: [BduiRemoteActionModel]) {
        let mapped: [ActionRequestModel] = actions.compactMap { action in
            switch action {
            case .command(let cmd):
                let params = cmd.params?.mapValues { value in
                    localStateResolver.resolveLocalStateRefs(value)
                }
                return .command(.init(name: cmd.name, params: params))

            case .updateScreen(let upd):
                let current = uiStateContent
                let screenHashes = ActionRequestModel.UpdateScreenModel.ScreenHashes(
                    hashes: hashCollector.collect(componentTree: current.components).map { $0 }
                )
                let topBarHash = current.scaffold?.topBar.map {
                    ActionRequestModel.UpdateScreenModel.ScreenPartHashes(hashNode: hashCollector.collect($0))
                }
                let bottomBarHash = current.scaffold?.bottomBar.map {
                    ActionRequestModel.UpdateScreenModel.ScreenPartHashes(hashNode: hashCollector.collect($0))
                }
                return .updateScreen(.init(
                    screenName: upd.screenName,
                    screen: screenHashes,
                    topBar: topBarHash,
                    bottomBar: bottomBarHash,
                    screenNavigationParams: upd.screenNavigationParams
                ))
            }
        }

        remoteCommandsTask?.cancel()
        remoteCommandsTask = Task { [weak self] in
            guard let self else { return }
            for await state in interactor.doAction(request: ScreenDoActionRequestModel(actions: mapped)) {
                switch state {
                case .loading:
                    self.uiState.updateIfContent { s in
                        self.screenFactory.setLoadingScreen(screen: s, isLoading: true)
                    }
                case .error:
                    self.uiState.updateIfContent { s in
                        self.screenFactory.setLoadingScreen(screen: s, isLoading: false)
                    }
                    self.snackbar.show(text: self.resources.string("general_error_description"))
                    self.analytics.logErrorSnackbarShown(screenName: self.screenName, message: nil)
                case .success(let response):
                    for item in response.responses {
                        switch item {
                        case .command(let c):
                            self.onCommandResponse(c.response.data)
                        case .updateScreen(let u):
                            self.onUpdateScreenResponse(u.response)
                        }
                    }
                }
            }
        }
    }

    private func onCommandResponse(_ data: ActionResponseModel.CommandModel.Response.Data) {
        uiState.updateIfContent { s in
            screenFactory.setLoadingScreen(screen: s, isLoading: false)
        }
        if let message = data.fallbackMessage {
            snackbar.show(text: message)
            analytics.logErrorSnackbarShown(screenName: screenName, message: message)
        }
    }

    private func onUpdateScreenResponse(_ response: ActionResponseModel.UpdateScreenModel.Response) {
        uiState.updateIfContent { s in
            let started = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
            let patched = screenFactory.createPatchedScreen(screen: s, updateScreenResponse: response)
            let durationMs = Int64((clock_gettime_nsec_np(CLOCK_UPTIME_RAW) &- started) / 1_000_000)
            analytics.logScreenUpdated(
                screenName: screenName,
                updatedComponentsCount: response.screen.count,
                updateDurationMs: durationMs
            )
            return patched
        }
    }

    // MARK: - Navigation and misc

    private func onNavigateBack(updatePreviousScreen: Bool) {
        if updatePreviousScreen {
            _ = navigation.backWithResult(key: "SHOULD_UPDATE_SCREEN_KEY", value: .bool(true))
        } else {
            _ = navigation.back()
        }
        analytics.logUserNavigated(fromScreenName: screenName, toScreenName: nil, method: .BACK)
    }

    private func onRetry() {
        refreshTrigger.send(())
    }

    private func onNavigateTo(
        screenName: String,
        screenNavigationParams: [String: JSONValue]?,
        toBottomSheet: Bool
    ) {
        if toBottomSheet {
            _ = navigation.navigateToBottomSheet(.bduiBottomSheet(.init(screenName: screenName, screenParams: screenNavigationParams)))
        } else {
            _ = navigation.navigate(.bduiScreen(.init(screenName: screenName, screenParams: screenNavigationParams)))
        }
        analytics.logUserNavigated(fromScreenName: self.screenName, toScreenName: screenName, method: .NAVIGATE_TO)
    }

    private func onInputValueChanged(
        actions: [BduiInputValueChangedApplicableModel],
        newInputValue: String
    ) {
        actions.forEach { a in
            switch a {
            case .sendRemoteActions(let remote):
                onRemoteActions(remote.actions)
            case .setLocalStateFromInput(let v):
                onSetLocalStateFromInput(path: v.targetPath, newInputValue: newInputValue)
            }
        }
    }

    private func onSetLocalState(path: Path, newValue: JSONValue) {
        localStateStore.setJSON(path, value: newValue)
    }

    private func onSetLocalStateFromInput(path: PathModel, newInputValue: String) {
        localStateStore.set(path.value, value: newInputValue)
    }

    private func onUpdateScreenResultReceived() {
        onRemoteActions([
            .updateScreen(.init(screenName: screenName, screenNavigationParams: screenParams))
        ])
    }
}

