//
//  RenderedStyledTextRepresentationModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//



import Foundation

struct RenderedStyledTextRepresentationModel: Codable {
    let text: String
    let textStyle: RenderedTextStyleModel
    let colorStyle: RenderedColorStyleModel   

    private enum CodingKeys: String, CodingKey {
        case text
        case textStyle
        case colorStyle
    }
}
