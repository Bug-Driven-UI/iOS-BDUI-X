//
//  State.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum ViewState<T> {
    case loading
    case success(T)
    case error(Error?)
}

extension Result {
    func toState() -> ViewState<T> {
        switch self {
        case .success(let v): return .success(v)
        case .error(let e): return .error(e)
        }
    }
}

extension ViewState {
    func map<R>(_ transform: (T) -> R) -> ViewState<R> {
        switch self {
        case .loading: return .loading
        case .error(let e): return .error(e)
        case .success(let v): return .success(transform(v))
        }
    }
}
