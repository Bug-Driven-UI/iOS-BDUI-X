//
//  SnackbarDuration.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation

public enum SnackbarDuration: Equatable {
    case short
    case long
    case indefinite

    var timeInterval: TimeInterval? {
        switch self {
        case .short: return 4.0
        case .long: return 10.0
        case .indefinite: return nil
        }
    }
}

public struct SnackbarMessage: Equatable {
    public let text: String
    public let duration: SnackbarDuration

    public init(text: String, duration: SnackbarDuration = .short) {
        self.text = text
        self.duration = duration
    }
}
