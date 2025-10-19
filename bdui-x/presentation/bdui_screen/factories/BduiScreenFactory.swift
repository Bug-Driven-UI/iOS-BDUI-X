//
//  BduiScreenFactory.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import Foundation

import Foundation

public final class BduiScreenFactory {
    private let componentFactory: BduiComponentFactory
    private let screenPatchFactory: BduiScreenPatchFactory
    private let componentPatchManager: BduiScreenPatchManager

    public init(componentFactory: BduiComponentFactory,
                screenPatchFactory: BduiScreenPatchFactory,
                componentPatchManager: BduiScreenPatchManager) {
        self.componentFactory = componentFactory
        self.screenPatchFactory = screenPatchFactory
        self.componentPatchManager = componentPatchManager
    }

    public func create(screen: RenderedScreenModel) -> RenderedScreenUiModel {
        RenderedScreenUiModel(
            screenName: screen.screenName,
            version: screen.version,
            components: screen.components.map(componentFactory.create),
            scaffold: screen.scaffold.map { scaffold in
                BduiScaffoldUiModel(
                    topBar: scaffold.topBar.map(componentFactory.create),
                    bottomBar: scaffold.bottomBar.map(componentFactory.create)
                )
            },
            isLoading: false
        )
    }

    // Now consumes ActionResponseModel.UpdateScreenModel.Response (data-layer type)
    public func createPatchedScreen(
        screen: RenderedScreenUiModel,
        updateScreenResponse: ActionResponseModel.UpdateScreenModel.Response
    ) -> RenderedScreenUiModel {
        // Top bar
        let newTopBar: [BduiComponentUiModel]? = updateScreenResponse.topBar
            .map { patchData in
                // Bridge PatchData -> UpdateScreenPatchDataModel
                let bridged = patchData.map { $0.toUpdateScreenPatchDataModel() }
                let patches = screenPatchFactory.createPatches(
                    updates: bridged,
                    factory: componentFactory.create(component:)
                )
                return componentPatchManager.applyPatchesToRoot(
                    rootChildren: screen.scaffold?.topBar.asList() ?? [],
                    patches: patches
                )
            }

        // Bottom bar
        let newBottomBar: [BduiComponentUiModel]? = updateScreenResponse.bottomBar
            .map { patchData in
                let bridged = patchData.map { $0.toUpdateScreenPatchDataModel() }
                let patches = screenPatchFactory.createPatches(
                    updates: bridged,
                    factory: componentFactory.create(component:)
                )
                return componentPatchManager.applyPatchesToRoot(
                    rootChildren: screen.scaffold?.bottomBar.asList() ?? [],
                    patches: patches
                )
            }

        // Screen components
        let newComponents: [BduiComponentUiModel] = {
            let bridged = updateScreenResponse.screen.map { $0.toUpdateScreenPatchDataModel() }
            let patches = screenPatchFactory.createPatches(
                updates: bridged,
                factory: componentFactory.create(component:)
            )
            return componentPatchManager.applyPatchesToRoot(
                rootChildren: screen.components,
                patches: patches
            )
        }()

        return RenderedScreenUiModel(
            screenName: screen.screenName,
            version: screen.version,
            components: newComponents,
            scaffold: screen.scaffold.map { s in
                BduiScaffoldUiModel(
                    topBar: newTopBar?.first,
                    bottomBar: newBottomBar?.first
                )
            },
            isLoading: false
        )
    }

    public func setLoadingScreen(screen: RenderedScreenUiModel, isLoading: Bool) -> RenderedScreenUiModel {
        RenderedScreenUiModel(
            screenName: screen.screenName,
            version: screen.version,
            components: screen.components,
            scaffold: screen.scaffold,
            isLoading: isLoading
        )
    }
}

private extension Optional where Wrapped == BduiComponentUiModel {
    func asList() -> [BduiComponentUiModel] {
        self.map { [$0] } ?? []
    }
}
