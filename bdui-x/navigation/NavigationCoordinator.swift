//
//  NavigationCoordinator.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation
import Combine

@MainActor
final class NavigationCoordinator: ObservableObject {
    @Published var stack: [NavigationRoute] = [.startScreen]
    @Published var bottomSheet: BottomSheetRoute?

    private var bag: Set<AnyCancellable> = []

    init(manager: NavigationManager = .shared) {
        manager.commands
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cmd in
                self?.handle(cmd)
            }
            .store(in: &bag)
    }

    private func handle(_ cmd: NavigationCommand) {
        switch cmd {
        case .navigate(let r):
            stack.append(r)
        case .replace(let r):
            if stack.isEmpty { stack = [r] } else { stack[stack.count - 1] = r }
        case .back:
            if stack.count > 1 { stack.removeLast() }
        case .navigateSheet(let s):
            bottomSheet = s
        case .replaceWithSheet(let s):
            if stack.count > 1 { stack.removeLast() }
            bottomSheet = s
        case .dismissSheet:
            bottomSheet = nil
        }
    }
}
