//
//  UiStateKeyModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public enum UiStateKeyModel {
    case loading
    case error
    case content
}

public enum UiStateModel<T> {
    case loading
    case error
    case content(T)

    public var key: UiStateKeyModel {
        switch self {
        case .loading: return .loading
        case .error:   return .error
        case .content: return .content
        }
    }
}

extension UiStateModel: Equatable where T: Equatable {
    public static func == (lhs: UiStateModel<T>, rhs: UiStateModel<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.error, .error):
            return true
        case (.content(let a), .content(let b)):
            return a == b
        default:
            return false
        }
    }
}

public extension UiStateModel {
    func updatingIfContent(_ update: (T) -> T) -> UiStateModel<T> {
        switch self {
        case .content(let data):
            return .content(update(data))
        default:
            return self
        }
    }

    mutating func updateIfContent(_ update: (T) -> T) {
        self = updatingIfContent(update)
    }
}

public extension UiStateModel {
    func map<R>(_ transform: (T) -> R) -> UiStateModel<R> {
        switch self {
        case .loading: return .loading
        case .error: return .error
        case .content(let data): return .content(transform(data))
        }
    }

    func mergeWith(_ other: UiStateModel<T>, reducer: (T, T) -> T) -> UiStateModel<T> {
        switch self {
        case .loading: return .loading
        case .error: return .error
        case .content(let a):
            switch other {
            case .loading: return .loading
            case .error: return .error
            case .content(let b): return .content(reducer(a, b))
            }
        }
    }
}
