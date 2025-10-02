//
//  RenderedComponentCommon.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

protocol RenderedComponentCommon: Codable, Equatable {
    var id: String { get }
    var hash: String { get }
    var interactions: [RenderedInteractionModel] { get }
    var paddings: RenderedInsetsModel? { get }
    var margins: RenderedInsetsModel? { get }
    var width: RenderedSizeModel { get }
    var height: RenderedSizeModel { get }
    var backgroundColor: RenderedColorStyleModel? { get }
    var border: RenderedBorderModel? { get }
    var shape: RenderedShapeModel? { get }
}
