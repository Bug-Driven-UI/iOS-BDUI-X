//
//  IBduiScreenRepository.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

protocol IBduiScreenRepositorySwift {
    func getScreen(
        userId: String,
        request: ScreenRenderRequestModel
    ) async -> Result<RenderedScreenResponseModel>
}

