//
//  ImageComponent.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

struct ImageComponent: RenderedComponentCommon, Codable {
    let imageUrl: String
    let badge: RenderedBadgeModel?       
    let id: String
    let hash: String
    let interactions: [RenderedInteractionModel]
    let paddings: RenderedInsetsModel?
    let margins: RenderedInsetsModel?
    let width: RenderedSizeModel
    let height: RenderedSizeModel
    let backgroundColor: RenderedColorStyleModel?
    let border: RenderedBorderModel?
    let shape: RenderedShapeModel?
}
