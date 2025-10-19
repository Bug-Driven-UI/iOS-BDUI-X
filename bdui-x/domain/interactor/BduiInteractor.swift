//
//  BduiInteractor.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation
import Combine

public protocol IBduiInteractor {
    func getScreen(
        request: ScreenRenderRequestModel
    ) -> AsyncStream<StateModel<RenderedScreenResponseModel>>

    func doAction(
        request: ScreenDoActionRequestModel
    ) -> AsyncStream<StateModel<ScreenDoActionResponseModel>>
}
public final class BduiInteractor: IBduiInteractor {
    private let repository: IBduiScreenRepository

    public init(bduiScreenRepository: IBduiScreenRepository) {
        self.repository = bduiScreenRepository
    }

    public func getScreen(request: ScreenRenderRequestModel) -> AsyncStream<StateModel<RenderedScreenResponseModel>> {
        let userId = UUID().uuidString
        return AsyncStream { continuation in
            continuation.yield(.loading)
            Task {
                let result: ResultModel<RenderedScreenResponseModel> =
                    await repository.getScreen(userId: userId, request: request)
                continuation.yield(result.toStateModel())
                continuation.finish()
            }
        }
    }

    public func doAction(request: ScreenDoActionRequestModel) -> AsyncStream<StateModel<ScreenDoActionResponseModel>> {
        return AsyncStream { continuation in
            continuation.yield(.loading)
            Task {
                let result: ResultModel<ScreenDoActionResponseModel> =
                    await repository.doAction(request: request)
                continuation.yield(result.toStateModel())
                continuation.finish()
            }
        }
    }
}
