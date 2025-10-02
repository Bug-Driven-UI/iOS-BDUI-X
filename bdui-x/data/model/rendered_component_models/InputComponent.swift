//
//  InputComponent.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

struct InputComponent: RenderedComponentCommon {
    enum Mask: String, Codable, Equatable {
        case phone
    }
    let textWithStyle: RenderedStyledTextRepresentationModel
    let mask: Mask?
    let rightIcon: ImageComponent?
    let regex: RenderedRegexModel?
    let placeholder: RenderedPlaceholderModel?
    let hint: RenderedHintModel?
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
