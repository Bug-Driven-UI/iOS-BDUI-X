//
//  IBduiScreenRepository.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

public protocol IBduiScreenRepository {
    func getScreen(
        userId: String,
        request: ScreenRenderRequestModel
    ) async -> ResultModel<RenderedScreenResponseModel>

    func doAction(
        request: ScreenDoActionRequestModel
    ) async -> ResultModel<ScreenDoActionResponseModel>
}
