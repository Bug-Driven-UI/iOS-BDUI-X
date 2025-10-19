//
//  StateModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public enum StateModel<T> {
    case loading
    case success(T)
    case error(Error? = nil)
}

public extension StateModel {
    func map<R>(_ mapper: (T) -> R) -> StateModel<R> {
        switch self {
        case .loading: return .loading
        case .error(let e): return .error(e)
        case .success(let data): return .success(mapper(data))
        }
    }

    func mergeWith(_ other: StateModel<T>, reducer: (T, T) -> T) -> StateModel<T> {
        switch self {
        case .loading: return .loading
        case .error: return self
        case .success(let a):
            switch other {
            case .loading: return other
            case .error: return other
            case .success(let b): return .success(reducer(a, b))
            }
        }
    }
}

public extension ResultModel {
    func toStateModel() -> StateModel<T> {
        switch self {
        case .success(let v): return .success(v)
        case .error(let e): return .error(e)
        }
    }
}
