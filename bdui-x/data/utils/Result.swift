//
//  Result.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error? = nil)

    var value: T? {
        if case .success(let v) = self { return v }
        return nil
    }

    var failure: Error? {
        if case .error(let e) = self { return e }
        return nil
    }
}
extension Result {
    func map<R>(_ transform: (T) -> R) -> Result<R> {
        switch self {
        case .success(let v): return .success(transform(v))
        case .error(let e): return .error(e)
        }
    }

    func flatMap<R>(_ transform: (T) -> Result<R>) -> Result<R> {
        switch self {
        case .success(let v): return transform(v)
        case .error(let e): return .error(e)
        }
    }

    func toCompletableResult() -> Result<Completable> {
        switch self {
        case .success: return .success(.instance)
        case .error(let e): return .error(e)
        }
    }
}
