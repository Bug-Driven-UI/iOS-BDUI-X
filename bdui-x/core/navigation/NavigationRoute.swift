//
//  NavigationRoute.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

public enum NavigationRoute: Hashable, Identifiable, Codable {
    case startScreen
    case bduiScreen(BduiScreenArgs)

    public var id: String {
        switch self {
        case .startScreen: return "StartScreen"
        case .bduiScreen(let args): return "BduiScreen:\(args.screenName)"
        }
    }
}

public enum BottomSheetRoute: Hashable, Identifiable, Codable {
    case bduiBottomSheet(BduiBottomSheetArgs)

    public var id: String {
        switch self {
        case .bduiBottomSheet(let args): return "BduiBottomSheet:\(args.screenName)"
        }
    }
}
