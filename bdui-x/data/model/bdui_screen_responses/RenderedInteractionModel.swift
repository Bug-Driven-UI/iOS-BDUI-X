//
//  RenderedInteractionModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//



import Foundation

struct RenderedInteractionModel: Codable {
    let type: InteractionType
    let actions: [RenderedActionModel]

    enum InteractionType: String, Codable {
        case onClick = "onClick"
        case onShow = "onShow"
    }
}
