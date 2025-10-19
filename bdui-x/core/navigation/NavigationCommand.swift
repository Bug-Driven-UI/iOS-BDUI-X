//
//  NavigationCommand.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

public enum NavigationCommand {
    case navigate(NavigationRoute)
    case navigateToBottomSheet(BottomSheetRoute)
    case replace(NavigationRoute)
    case replaceWithBottomSheet(BottomSheetRoute)
    case back
    case backWithResult(key: String, value: JSONValue)
}
