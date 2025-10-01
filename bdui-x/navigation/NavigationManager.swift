//
//  NavigationManager.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation
import Combine

final class NavigationManager {
    static let shared = NavigationManager()
    private init() {}

    private let subject = PassthroughSubject<NavigationCommand, Never>()
    var commands: AnyPublisher<NavigationCommand, Never> { subject.eraseToAnyPublisher() }

    @discardableResult
    func send(_ cmd: NavigationCommand) -> Bool {
        subject.send(cmd)
        return true
    }

    func navigate(_ route: NavigationRoute) { send(.navigate(route)) }
    func replace(_ route: NavigationRoute) { send(.replace(route)) }
    func back() { send(.back) }
    func showSheet(_ sheet: BottomSheetRoute) { send(.navigateSheet(sheet)) }
    func replaceWithSheet(_ sheet: BottomSheetRoute) { send(.replaceWithSheet(sheet)) }
    func dismissSheet() { send(.dismissSheet) }
}
