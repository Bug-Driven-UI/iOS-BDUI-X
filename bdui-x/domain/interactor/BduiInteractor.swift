//
//  BduiInteractor.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

protocol BduiInteractor {
    func getScreen(
        request: ScreenRenderRequestModel
    ) -> AsyncThrowingStream<OperationState<RenderedScreenModel>, Error>

    func doActions(
        request: ScreenDoActionRequestModel
    ) -> AsyncThrowingStream<OperationState<ScreenDoActionResponseModel>, Error>
}
