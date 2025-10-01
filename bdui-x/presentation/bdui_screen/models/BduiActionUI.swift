//
//  BduiActionUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

enum BduiActionUI {
    
    enum Remote {
        case command(name: String, params: [String: JSONValue]?)
        case updateScreen(name: String, params: [String: JSONValue]?)
    }

    case sendRemoteActions([Remote])
    case navigateTo(screen: String, params: [String: JSONValue]?)
    case navigateBack
    case retry
}
