//
//  ScreenRepository.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

public final class BduiScreenRepository: IBduiScreenRepository {
    private let api: BduiApi

    public init(api: BduiApi) {
        self.api = api
    }

    public func getScreen(
        userId: String,
        request: ScreenRenderRequestModel
    ) async -> ResultModel<RenderedScreenResponseModel> {
        await api.getRenderedScreen(userId: userId, request: request)
    }

    public func doAction(
        request: ScreenDoActionRequestModel
    ) async -> ResultModel<ScreenDoActionResponseModel> {
        await api.doAction(request: request)
    }
}
