//
//  BduiApi.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public protocol BduiApi {
    func getRenderedScreen(
        userId: String,
        request: ScreenRenderRequestModel
    ) async -> ResultModel<RenderedScreenResponseModel>

    func doAction(
        request: ScreenDoActionRequestModel
    ) async -> ResultModel<ScreenDoActionResponseModel>
}
