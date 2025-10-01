//
//  NavigationRoute.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

enum NavigationRoute: Hashable, Identifiable, Codable {
    case startScreen
    case bduiScreen(BduiScreenArgs)

    var id: String {
        switch self {
        case .startScreen: return "start"
        case .bduiScreen(let a): return "bdui:\(a.screenId)"
        }
    }
}

enum BottomSheetRoute: Hashable, Identifiable {
    case bdui(BduiBottomSheetArgs)

    var id: String {
        switch self {
        case .bdui(let a): return "sheet.bdui:\(a.screenId)"
        }
    }
}
