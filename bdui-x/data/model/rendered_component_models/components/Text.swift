//
//  TextComponent.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

public struct TextModel: Equatable, Codable {
       public let type: String = "text"

       public let textWithStyle: RenderedStyledTextRepresentationModel

       public let id: String
       public let hash: String
       public let interactions: [RenderedInteractionModel]
       public let paddings: RenderedInsetsModel?
       public let margins: RenderedInsetsModel?
       public let width: RenderedSizeModel
       public let height: RenderedSizeModel
       public let backgroundColor: RenderedColorStyleModel?
       public let border: RenderedBorderModel?
       public let shape: RenderedShapeModel?

       private enum CodingKeys: String, CodingKey {
           case type, textWithStyle
           case id, hash, interactions, paddings, margins, width, height, backgroundColor, border, shape
       }

       public init(
           textWithStyle: RenderedStyledTextRepresentationModel,
           id: String,
           hash: String,
           interactions: [RenderedInteractionModel] = [],
           paddings: RenderedInsetsModel? = nil,
           margins: RenderedInsetsModel? = nil,
           width: RenderedSizeModel,
           height: RenderedSizeModel,
           backgroundColor: RenderedColorStyleModel? = nil,
           border: RenderedBorderModel? = nil,
           shape: RenderedShapeModel? = nil
       ) {
           self.textWithStyle = textWithStyle
           self.id = id
           self.hash = hash
           self.interactions = interactions
           self.paddings = paddings
           self.margins = margins
           self.width = width
           self.height = height
           self.backgroundColor = backgroundColor
           self.border = border
           self.shape = shape
       }

       public init(from decoder: Decoder) throws {
           let c = try decoder.container(keyedBy: CodingKeys.self)
           self.textWithStyle = try c.decode(RenderedStyledTextRepresentationModel.self, forKey: .textWithStyle)
           self.id = try c.decode(String.self, forKey: .id)
           self.hash = try c.decode(String.self, forKey: .hash)
           self.interactions = try c.decodeIfPresent([RenderedInteractionModel].self, forKey: .interactions) ?? []
           self.paddings = try c.decodeIfPresent(RenderedInsetsModel.self, forKey: .paddings)
           self.margins = try c.decodeIfPresent(RenderedInsetsModel.self, forKey: .margins)
           self.width = try c.decode(RenderedSizeModel.self, forKey: .width)
           self.height = try c.decode(RenderedSizeModel.self, forKey: .height)
           self.backgroundColor = try c.decodeIfPresent(RenderedColorStyleModel.self, forKey: .backgroundColor)
           self.border = try c.decodeIfPresent(RenderedBorderModel.self, forKey: .border)
           self.shape = try c.decodeIfPresent(RenderedShapeModel.self, forKey: .shape)
       }

       public func encode(to encoder: Encoder) throws {
           var c = encoder.container(keyedBy: CodingKeys.self)
           try c.encode(type, forKey: .type)
           try c.encode(textWithStyle, forKey: .textWithStyle)
           try c.encode(id, forKey: .id)
           try c.encode(hash, forKey: .hash)
           try c.encode(interactions, forKey: .interactions)
           try c.encodeIfPresent(paddings, forKey: .paddings)
           try c.encodeIfPresent(margins, forKey: .margins)
           try c.encode(width, forKey: .width)
           try c.encode(height, forKey: .height)
           try c.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
           try c.encodeIfPresent(border, forKey: .border)
           try c.encodeIfPresent(shape, forKey: .shape)
       }
   }
