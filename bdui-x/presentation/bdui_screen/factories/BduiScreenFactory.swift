//
//  BduiScreenFactory.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

final class BduiScreenFactory {

    private let componentFactory: BduiComponentFactory
    private let patchFactory: BduiScreenPatchFactory
    private let patchManager: BduiScreenPatchManager

    init(componentFactory: BduiComponentFactory,
         patchFactory: BduiScreenPatchFactory,
         patchManager: BduiScreenPatchManager) {
        self.componentFactory = componentFactory
        self.patchFactory = patchFactory
        self.patchManager = patchManager
    }

    func create(screen: RenderedScreenModel) -> RenderedScreenUi {
        RenderedScreenUi(
            screenName: screen.screenName,
            version: screen.version,
            components: screen.components.map(componentFactory.create),
            scaffold: screen.scaffold.map { sc in
                BduiScaffoldUI(
                    topBar: sc.topBar.map(componentFactory.create),
                    bottomBar: sc.bottomBar.map(componentFactory.create)
                )
            },
            isLoading: false
        )
    }

    func createPatchedScreen(
        screen: RenderedScreenUi,
        updateScreenResponse: ActionResponseModel.UpdateScreen.Response
    ) -> RenderedScreenUi {
        let patches = patchFactory.createPatches(
            updates: updateScreenResponse.data
        ) { rendered in
            componentFactory.create(rendered)
        }
        let newChildren = patchManager.applyPatchesToRoot(
            rootChildren: screen.components,
            patches: patches
        )
        return screen.copy(components: newChildren, isLoading: false)
    }

    func setLoadingScreen(screen: RenderedScreenUi, isLoading: Bool) -> RenderedScreenUi {
        screen.withLoading(isLoading)
    }
}
