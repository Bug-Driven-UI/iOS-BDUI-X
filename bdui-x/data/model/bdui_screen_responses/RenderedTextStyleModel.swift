//
//  RenderedTextStyleModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//



import Foundation

struct RenderedTextStyleModel: Codable,Equatable {
    let decoration: RenderedTextDecorationTypeModel?
    let weight: Int?
    let size: Int
    let lineHeight: Int
}
