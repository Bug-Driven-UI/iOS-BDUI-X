//
//  BduiScreenView.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Combine
import SwiftUI

public struct BduiScreenView<Args>: View {
    private let args: Args
    private let isBottomSheet: Bool

    private let resultStore: NavigationResultStore

    @StateObject private var viewModel: BduiScreenViewModel
    @State private var resultCancellable: AnyCancellable?

    public init(args: Args, isBottomSheet: Bool, dependencies: AppDependencies) {
        self.args = args
        self.isBottomSheet = isBottomSheet
        self.resultStore = dependencies.navigationResults

        // Extract required fields from args
        let screenName: String
        let screenParams: [String: JSONValue]?

        if let typed = args as Any as? (screenName: String, screenParams: [String: JSONValue]?) {
            screenName = typed.screenName
            screenParams = typed.screenParams
        } else if
            let mirrorName = Mirror(reflecting: args).children.first(where: { $0.label == "screenName" })?.value as? String
        {
            screenName = mirrorName
            let params = Mirror(reflecting: args).children.first(where: { $0.label == "screenParams" })?.value as? [String: JSONValue]
            screenParams = params
        } else {
            fatalError("BduiScreenView: Args must contain `screenName: String` and `screenParams: [String: JSONValue]?`")
        }

        let localStateStore = LocalStateStore()
        let localStateResolver = LocalStateResolver(localStateStore: localStateStore)

        let mapper = BduiComponentPropertiesMapper(localStateResolver: localStateResolver)
        let componentFactory = BduiComponentFactory(localStateResolver: localStateResolver, mapper: mapper)
        let screenPatchFactory = BduiScreenPatchFactory()
        let patchManager = BduiScreenPatchManager()
        let screenFactory = BduiScreenFactory(
            componentFactory: componentFactory,
            screenPatchFactory: screenPatchFactory,
            componentPatchManager: patchManager
        )
        let hashCollector = BduiScreenHashCollector()

        let vm = BduiScreenViewModel(
            screenName: screenName,
            screenParams: screenParams,
            interactor: dependencies.interactor,
            screenFactory: screenFactory,
            hashCollector: hashCollector,
            navigation: dependencies.navigationManager,
            snackbar: dependencies.snackbarManager,
            resources: dependencies.resources,
            analytics: dependencies.analytics,
            localStateStore: localStateStore,
            localStateResolver: localStateResolver
        )
        _viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        BduiScreen(viewModel: viewModel, isBottomSheet: isBottomSheet)
            .onAppear {
                resultCancellable = resultStore.publisher(for: "SHOULD_UPDATE_SCREEN_KEY")
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        if case .some(.bool(true)) = resultStore.consume("SHOULD_UPDATE_SCREEN_KEY") {
                            viewModel.onAction(.updateScreenResultReceived)
                        }
                    }
            }
            .onDisappear {
                resultCancellable?.cancel()
                resultCancellable = nil
            }
            .ignoresSafeArea(.container, edges: [.top, .bottom])
    }
}

public struct BduiScreen: View {
    @ObservedObject var viewModel: BduiScreenViewModel
    let isBottomSheet: Bool

    public init(viewModel: BduiScreenViewModel, isBottomSheet: Bool = false) {
        self.viewModel = viewModel
        self.isBottomSheet = isBottomSheet
    }

    public var body: some View {
        Group {
            content
        }
        .ignoresSafeArea()
        .task {
            await MainActor.run {
                DispatchQueue.main.async {
                    viewModel.onAction(.screenShown)
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.uiState.key {
        case .loading:
            LoaderScreen().frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error:
            ErrorScreen(onRetry: { viewModel.onAction(.retry) })
                .task(id: viewModel.uiState.key) {
                    if viewModel.uiState.key == .error {
                        DispatchQueue.main.async {
                            viewModel.onAction(.errorScreenShown)
                        }
                    }
                }

        case .content:
            if isBottomSheet {
                BduiBottomSheet(uiState: viewModel.uiState, onAction: { viewModel.onAction($0) })
            } else {
                BduiScreenScaffold(model: viewModel.uiStateContent, onAction: { viewModel.onAction($0) })
            }
        }
    }
}

// MARK: - Scaffold

private struct BduiScreenScaffold: View {
    let model: RenderedScreenUiModel
    let onAction: (BduiActionUiModel) -> Void

    @State private var renderingStartNs: UInt64 = 0
    @State private var reported = false

    var body: some View {
        let _ = startMeasureIfNeeded()

        ZStack {
            // Solid background under everything and across the full screen
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                if let topBar = model.scaffold?.topBar {
                    TopBar(component: topBar, onAction: onAction)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.white)
                }

                BduiScreenContent(model: model, onAction: onAction)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(
                        GeometryReader { _ in
                            Color.clear
                                .onAppear { reportIfNeeded() }
                        }
                    )
                    .ignoresSafeArea()

                if let bottomBar = model.scaffold?.bottomBar {
                    BottomBar(component: bottomBar, onAction: onAction)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay {
            if model.isLoading {
                LoaderScreen().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    @discardableResult
    private func startMeasureIfNeeded() -> Bool {
        if renderingStartNs == 0 {
            renderingStartNs = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
        }
        return true
    }

    private func reportIfNeeded() {
        guard !reported else { return }
        reported = true
        let now = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
        let ms = Int64((now &- renderingStartNs) / 1_000_000)

        onAction(.screenRendered(.init(
            renderTimeMs: ms,
            screenVersion: model.version,
            components: model.components
        )))
    }
}

// MARK: - Content

private struct BduiScreenContent: View {
    let model: RenderedScreenUiModel
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 0) {
                ForEach(Array(model.components.enumerated()), id: \.0) { _, component in
                    BduiComponent(component: component, onAction: onAction)
                        .bduiBaseProperties(
                            base: component.basePropertiesValue,
                            onAction: onAction,
                            buttonEnabled: component.buttonEnabledValue
                        )
                }
                Spacer().frame(height: 1)
            }
        }
        .background(.clear)
        .ignoresSafeArea(.all)
    }
}

// MARK: - Bottom sheet

private struct BduiBottomSheet: View {
    let uiState: UiStateModel<RenderedScreenUiModel>
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        switch uiState {
        case .content(let data):
            ZStack {
                BduiBottomSheetContent(model: data, onAction: onAction)
                if data.isLoading { LoaderScreen() }
            }
        case .error:
            Color.clear
                .onAppear { onAction(.navigateBack(.init(updatePreviousScreen: false))) }
        case .loading:
            LoaderScreen()
                .frame(width: 375, height: 375)
        }
    }
}

private struct BduiBottomSheetContent: View {
    let model: RenderedScreenUiModel
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(model.components.enumerated()), id: \.0) { _, component in
                    BduiComponent(component: component, onAction: onAction)
                        .bduiBaseProperties(
                            base: component.basePropertiesValue,
                            onAction: onAction,
                            buttonEnabled: component.buttonEnabledValue
                        )
                }
                Spacer().frame(height: 16)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.container, edges: [.top, .bottom])
    }
}

// MARK: - Top/Bottom bars

private struct TopBar: View {
    let component: BduiComponentUiModel
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        BduiComponent(component: component, onAction: onAction)
            .bduiBaseProperties(
                base: component.basePropertiesValue,
                onAction: onAction,
                buttonEnabled: component.buttonEnabledValue
            )
        // Removed padding with safe area insets
    }
}

private struct BottomBar: View {
    let component: BduiComponentUiModel
    let onAction: (BduiActionUiModel) -> Void

    var body: some View {
        BduiComponent(component: component, onAction: onAction)
            .bduiBaseProperties(
                base: component.basePropertiesValue,
                onAction: onAction,
                buttonEnabled: component.buttonEnabledValue
            )
            .shadow(color: Color.black.opacity(0.15), radius: 8, y: -2)
        // Removed padding with safe area insets
    }
}

// MARK: - Helpers from component models

private extension BduiComponentUiModel {
    var basePropertiesValue: BduiBasePropertiesModel {
        switch self {
        case .textModel(let m): return m.baseProperties
        case .imageModel(let m): return m.baseProperties
        case .buttonModel(let m): return m.baseProperties
        case .inputModel(let m): return m.baseProperties
        case .spacerModel(let m): return m.baseProperties
        case .rowModel(let m): return m.baseProperties
        case .columnModel(let m): return m.baseProperties
        case .boxModel(let m): return m.baseProperties
        }
    }

    var buttonEnabledValue: Bool? {
        switch self {
        case .buttonModel(let m): return m.enabled
        default: return nil
        }
    }
}

// MARK: - Safe area helper

private extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets ?? .zero
    }
}
