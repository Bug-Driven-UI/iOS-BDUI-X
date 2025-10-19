//
//  NavigationManager.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation
import Combine

public final class NavigationManager {
    public let commands = PassthroughSubject<NavigationCommand, Never>()

    public init() {}

    @discardableResult
    public func tryAddCommand(_ command: NavigationCommand) -> Bool {
        commands.send(command)
        return true
    }

    @discardableResult
    public func navigate(_ route: NavigationRoute) -> Bool {
        tryAddCommand(.navigate(route))
    }

    @discardableResult
    public func navigateToBottomSheet(_ route: BottomSheetRoute) -> Bool {
        tryAddCommand(.navigateToBottomSheet(route))
    }

    @discardableResult
    public func replace(_ route: NavigationRoute) -> Bool {
        tryAddCommand(.replace(route))
    }

    @discardableResult
    public func replaceWithBottomSheet(_ route: BottomSheetRoute) -> Bool {
        tryAddCommand(.replaceWithBottomSheet(route))
    }

    @discardableResult
    public func back() -> Bool {
        tryAddCommand(.back)
    }

    @discardableResult
    public func backWithResult(key: String, value: JSONValue) -> Bool {
        tryAddCommand(.backWithResult(key: key, value: value))
    }
}
