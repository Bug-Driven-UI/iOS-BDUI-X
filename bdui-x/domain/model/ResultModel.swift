//
//  Result.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

public enum ResultModel<T> {
    case success(T)
    case error(Error? = nil)

    public var value: T? {
        if case .success(let v) = self { return v }
        return nil
    }

    public var failure: Error? {
        if case .error(let e) = self { return e }
        return nil
    }

    public func map<R>(_ transform: (T) -> R) -> ResultModel<R> {
        switch self {
        case .success(let v): return .success(transform(v))
        case .error(let e): return .error(e)
        }
    }

    public func flatMap<R>(_ transform: (T) -> ResultModel<R>) -> ResultModel<R> {
        switch self {
        case .success(let v): return transform(v)
        case .error(let e): return .error(e)
        }
    }

    public func toCompletableResult() -> ResultModel<CompletableModel> {
        switch self {
        case .success: return .success(.instance)
        case .error(let e): return .error(e)
        }
    }
}

public struct CompletableModel: Codable, Sendable {
    public static let instance = CompletableModel()
}
