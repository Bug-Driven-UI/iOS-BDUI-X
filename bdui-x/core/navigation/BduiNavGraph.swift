//
//  BduiNavGraph.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Combine
import SwiftUI
import UIKit

public struct BduiNavGraph<StartView: View, BduiView: View>: UIViewControllerRepresentable {
    public typealias BuildStart = () -> StartView
    public typealias BuildBduiScreen = (_ args: BduiScreenArgs, _ isBottomSheet: Bool) -> BduiView

    private let navigationManager: NavigationManager
    private let resultStore: NavigationResultStore
    private let buildStart: BuildStart
    private let buildBduiScreen: BuildBduiScreen

    public init(
        navigationManager: NavigationManager,
        resultStore: NavigationResultStore,
        @ViewBuilder start: @escaping BuildStart,
        @ViewBuilder bduiScreen: @escaping BuildBduiScreen
    ) {
        self.navigationManager = navigationManager
        self.resultStore = resultStore
        self.buildStart = start
        self.buildBduiScreen = bduiScreen
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        let root = FullScreenWrapper(content: buildStart(), background: .white)
        let rootVC = UIHostingController(rootView: root)
        configureHostingVC(rootVC)

        let nav = UINavigationController(rootViewController: rootVC)
        // Make navigation controller fully opaque white; avoid any translucency bleeding
        nav.view.isOpaque = true
        nav.view.backgroundColor = .white
        nav.navigationBar.isHidden = true
        nav.navigationBar.isTranslucent = false
        nav.isToolbarHidden = true
        nav.modalPresentationCapturesStatusBarAppearance = true
        nav.setNavigationBarHidden(true, animated: false)
        nav.interactivePopGestureRecognizer?.isEnabled = true
        nav.definesPresentationContext = true

        context.coordinator.attach(
            navController: nav,
            navigationManager: navigationManager,
            resultStore: resultStore,
            buildStart: buildStart,
            buildBduiScreen: buildBduiScreen
        )
        return nav
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let root = uiViewController.viewControllers.first as? UIHostingController<FullScreenWrapper<StartView>> {
            root.rootView = FullScreenWrapper(content: buildStart(), background: .white)
            configureHostingVC(root)
        }
        // Keep nav opaque on any external changes
        uiViewController.view.isOpaque = true
        uiViewController.view.backgroundColor = .white
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        private weak var nav: UINavigationController?
        private var sub: AnyCancellable?
        private var queue: [NavigationCommand] = []
        private var isTransitioning = false

        private var routes: [NavigationRoute] = []

        private var sheetController: UIViewController?
        private var isSheetAlreadyDismissing = false

        private var buildStart: BuildStart!
        private var buildBduiScreen: BuildBduiScreen!
        private weak var resultStore: NavigationResultStore?

        func attach(
            navController: UINavigationController,
            navigationManager: NavigationManager,
            resultStore: NavigationResultStore,
            buildStart: @escaping BuildStart,
            buildBduiScreen: @escaping BuildBduiScreen
        ) {
            nav = navController
            self.resultStore = resultStore
            self.buildStart = buildStart
            self.buildBduiScreen = buildBduiScreen

            sub = navigationManager.commands
                .receive(on: DispatchQueue.main)
                .sink { [weak self] cmd in
                    self?.enqueue(cmd)
                }
        }

        private func enqueue(_ command: NavigationCommand) {
            queue.append(command)
            processNextIfIdle()
        }

        private func processNextIfIdle() {
            guard !isTransitioning, !queue.isEmpty else { return }
            isTransitioning = true
            let cmd = queue.removeFirst()
            handle(cmd)
        }

        private func finishTransition() {
            isTransitioning = false
            processNextIfIdle()
        }

        private func push<V: View>(_ view: V, animated: Bool = true) {
            guard let nav else { finishTransition(); return }
            let vc = UIHostingController(rootView: FullScreenWrapper(content: view, background: .white))
            configureHostingVC(vc)
            vc.navigationItem.largeTitleDisplayMode = .never
            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in self?.finishTransition() }
            nav.pushViewController(vc, animated: animated)
            CATransaction.commit()
        }

        private func setStack(_ vcs: [UIViewController], animated: Bool = false, completion: (() -> Void)? = nil) {
            guard let nav else { completion?(); finishTransition(); return }
            // Ensure every VC is configured (opaque, extended under edges)
            vcs.forEach { configureHostingVC($0) }

            nav.view.isOpaque = true
            nav.view.backgroundColor = .white

            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in
                completion?()
                if completion == nil { self?.finishTransition() }
            }
            nav.setViewControllers(vcs, animated: animated)
            CATransaction.commit()
        }

        private func presentSheet<V: View>(_ view: V) {
            guard let nav else { finishTransition(); return }

            let sheetVC = UIHostingController(rootView: FullScreenWrapper(content: view, background: .white))
            configureHostingVC(sheetVC)
            sheetVC.modalPresentationStyle = .pageSheet
            if let sheet = sheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.selectedDetentIdentifier = .medium
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
            }
            sheetVC.presentationController?.delegate = self

            isSheetAlreadyDismissing = false
            nav.present(sheetVC, animated: true) { [weak self] in
                self?.finishTransition()
            }
            sheetController = sheetVC
        }

        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            sheetController = nil
            isSheetAlreadyDismissing = false
        }

        private func buildViewController(for route: NavigationRoute) -> UIViewController {
            switch route {
            case .startScreen:
                let vc = UIHostingController(rootView: FullScreenWrapper(content: buildStart(), background: .white))
                configureHostingVC(vc)
                return vc
            case .bduiScreen(let args):
                let vc = UIHostingController(rootView: FullScreenWrapper(content: buildBduiScreen(args, false), background: .white))
                configureHostingVC(vc)
                return vc
            }
        }

        private func setBackLocked(_ locked: Bool) {
            nav?.interactivePopGestureRecognizer?.isEnabled = !locked
        }

        private func handle(_ command: NavigationCommand) {
            switch command {
            case .navigate(let route):
                if case .bduiScreen = route, routes.last == .startScreen {
                    routes = [route]
                    let vc = buildViewController(for: route)
                    setStack([vc], animated: true)
                    setBackLocked(true)
                    return
                }

                routes.append(route)
                switch route {
                case .startScreen:
                    push(buildStart())
                    setBackLocked(false)
                case .bduiScreen(let args):
                    push(buildBduiScreen(args, false))
                    setBackLocked(true)
                }

            case .navigateToBottomSheet(let sheet):
                switch sheet {
                case .bduiBottomSheet(let args):
                    let screenArgs = BduiScreenArgs(screenName: args.screenName, screenParams: args.screenParams)
                    presentSheet(buildBduiScreen(screenArgs, true))
                }

            case .replace(let route):
                routes = [route]
                let vc = buildViewController(for: route)
                setStack([vc], animated: false)
                setBackLocked(route.isBdui)

            case .replaceWithBottomSheet(let sheet):
                if !routes.isEmpty { routes.removeLast() }
                guard let nav = nav else { finishTransition(); return }
                var vcs = nav.viewControllers
                if vcs.count > 1 { vcs.removeLast() }

                switch sheet {
                case .bduiBottomSheet(let args):
                    let screenArgs = BduiScreenArgs(screenName: args.screenName, screenParams: args.screenParams)
                    setStack(vcs, animated: false) { [weak self] in
                        guard let self = self else { return }
                        self.presentSheet(self.buildBduiScreen(screenArgs, true))
                    }
                }

            case .back:
                if routes.last?.isBdui == true, (nav?.viewControllers.count ?? 1) <= 1 {
                    finishTransition()
                    return
                }
                if let _ = sheetController, !isSheetAlreadyDismissing {
                    isSheetAlreadyDismissing = true
                    sheetController?.dismiss(animated: true) { [weak self] in
                        self?.sheetController = nil
                        self?.isSheetAlreadyDismissing = false
                        self?.finishTransition()
                    }
                } else if let nav, nav.viewControllers.count > 1 {
                    routes.removeLast()
                    CATransaction.begin()
                    CATransaction.setCompletionBlock { [weak self] in
                        self?.setBackLocked(self?.routes.last?.isBdui == true)
                        self?.finishTransition()
                    }
                    nav.popViewController(animated: true)
                    CATransaction.commit()
                } else {
                    finishTransition()
                }

            case .backWithResult(let key, let value):
                resultStore?.set(key, value: value)
                if routes.last?.isBdui == true, (nav?.viewControllers.count ?? 1) <= 1 {
                    finishTransition()
                    return
                }
                if let _ = sheetController, !isSheetAlreadyDismissing {
                    isSheetAlreadyDismissing = true
                    sheetController?.dismiss(animated: true) { [weak self] in
                        self?.sheetController = nil
                        self?.isSheetAlreadyDismissing = false
                        self?.finishTransition()
                    }
                } else if let nav, nav.viewControllers.count > 1 {
                    routes.removeLast()
                    CATransaction.begin()
                    CATransaction.setCompletionBlock { [weak self] in
                        self?.setBackLocked(self?.routes.last?.isBdui == true)
                        self?.finishTransition()
                    }
                    nav.popViewController(animated: true)
                    CATransaction.commit()
                } else {
                    finishTransition()
                }
            }
        }
    }
}

// Force every hosted VC to be full-bleed and opaque.
private func configureHostingVC(_ vc: UIViewController) {
    vc.view.isOpaque = true
    vc.view.backgroundColor = .white
    vc.modalPresentationCapturesStatusBarAppearance = true

    // Extend under all edges so SwiftUI content (with ignoresSafeArea) truly fills the screen
    vc.edgesForExtendedLayout = [.top, .bottom, .left, .right]
    vc.extendedLayoutIncludesOpaqueBars = true
    vc.additionalSafeAreaInsets = .zero
    vc.view.insetsLayoutMarginsFromSafeArea = false

    // Ensure it resizes with its parent during transitions/rotations
    vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
}

struct FullScreenWrapper<Content: View>: View {
    let content: Content
    let background: Color

    init(content: Content, background: Color = .white) {
        self.content = content
        self.background = background
    }

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .ignoresSafeArea()
    }
}

private extension NavigationRoute {
    var isBdui: Bool {
        if case .bduiScreen = self { return true }
        return false
    }
}
