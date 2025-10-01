//
//  NavigationCommand.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum NavigationCommand {
    case navigate(NavigationRoute)
    case replace(NavigationRoute)
    case back
    case navigateSheet(BottomSheetRoute)
    case replaceWithSheet(BottomSheetRoute)
    case dismissSheet
}
