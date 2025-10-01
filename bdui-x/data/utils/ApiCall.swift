//
//  ApiCall.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

@discardableResult
func apiCall<T>(_ block: () async throws -> Result<T>) async -> Result<T> {
    do {
        return try await block()
    } catch {
        return .error(error)
    }
}
