//
//  RenderedShapeModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


// RenderedShapeModel.swift
import Foundation

struct RenderedShapeModel: Codable {
    let type: ShapeType
    let topRight: Int
    let topLeft: Int
    let bottomRight: Int
    let bottomLeft: Int

    enum ShapeType: String, Codable {
        case roundedCorners = "roundedCorners"
    }
}
