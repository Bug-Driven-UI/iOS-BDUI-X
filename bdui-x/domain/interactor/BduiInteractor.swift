//
//  BduiInteractor.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

final class BduiInteractor {
    private let repository: ScreenRepository

    init(repository: ScreenRepository) {
        self.repository = repository
    }

    func loadScreen(screenId: String, params: [String: JSONValue]) async -> ViewState<RenderedScreenResponseModel> {
        let result = await repository.fetchScreen(name: screenId)
        return result.toState()
    }
}
