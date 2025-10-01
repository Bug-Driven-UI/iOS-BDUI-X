//
//  ScreenRepository.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

actor ScreenRepository {
    func fetchScreen(name: String) async -> Result<RenderedScreenResponseModel> {
        await apiCall {
            await APISession.shared.requestDecodable(APIRoute.getScreen(name: name))
        }
    }

    func submit(payload: SomePayloadModel) async -> Result<Completable> {
        await apiCall {
            await APISession.shared.requestCompletable(APIRoute.submitForm(payload: payload))
        }
    }
}

struct SomePayloadModel: FormPayload {
    let field: String
}
extension ScreenRepository: IBduiScreenRepositorySwift {
    func getScreen(
        userId: String,
        request: ScreenRenderRequestModel
    ) async -> Result<RenderedScreenResponseModel> {
        await fetchScreen(name: request.data.screenName)
    }
}
