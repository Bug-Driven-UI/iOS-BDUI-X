//
//  NavigationControllerHost.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import SwiftUI
import UIKit


struct NavigationControllerHost<Root: View>: UIViewControllerRepresentable {
    typealias RouteBuilder = (NavigationRoute) -> AnyView

    let root: Root
    let routeBuilder: RouteBuilder
    @Binding var stack: [NavigationRoute]

    final class Coordinator: NSObject, UINavigationControllerDelegate {
        var navController: UINavigationController?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let rootVC = UIHostingController(rootView: root)
        let nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.isHidden = true
        nav.isToolbarHidden = true
        nav.view.backgroundColor = .clear
        nav.modalPresentationCapturesStatusBarAppearance = true
        nav.setNavigationBarHidden(true, animated: false)
        context.coordinator.navController = nav
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        var desired: [UIViewController] = []
        if let first = uiViewController.viewControllers.first as? UIHostingController<Root> {
            first.rootView = root
            desired.append(first)
        } else {
            desired.append(UIHostingController(rootView: root))
        }
        for route in stack {
            let vc = UIHostingController(rootView: routeBuilder(route))
            vc.navigationItem.largeTitleDisplayMode = .never
            desired.append(vc)
        }

        if uiViewController.viewControllers.map(ObjectIdentifier.init) != desired.map(ObjectIdentifier.init) {
            let animated = true
            uiViewController.setViewControllers(desired, animated: animated)
        }
    }
}
