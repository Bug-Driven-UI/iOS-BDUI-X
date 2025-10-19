//
//  InputComponent.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

public struct InputModel: Equatable, Codable {
       public let type: String = "input"

       public let textWithStyle: RenderedStyledTextRepresentationModel
       public let mask: Mask?
       public let rightIcon: ImageModel?
       public let regex: RenderedRegexModel?
       public let placeholder: RenderedPlaceholderModel?
       public let onValueChanged: [RenderedActionModel]?

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

       public enum Mask: String, Codable, Equatable {
           case phone = "phone"
       }

       private enum CodingKeys: String, CodingKey {
           case type, textWithStyle, mask, rightIcon, regex, placeholder, onValueChanged
           case id, hash, interactions, paddings, margins, width, height, backgroundColor, border, shape
       }

       public init(
           textWithStyle: RenderedStyledTextRepresentationModel,
           mask: Mask? = nil,
           rightIcon: ImageModel? = nil,
           regex: RenderedRegexModel? = nil,
           placeholder: RenderedPlaceholderModel? = nil,
           onValueChanged: [RenderedActionModel]? = nil,
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
           self.mask = mask
           self.rightIcon = rightIcon
           self.regex = regex
           self.placeholder = placeholder
           self.onValueChanged = onValueChanged
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
           self.mask = try c.decodeIfPresent(Mask.self, forKey: .mask)
           self.rightIcon = try c.decodeIfPresent(ImageModel.self, forKey: .rightIcon)
           self.regex = try c.decodeIfPresent(RenderedRegexModel.self, forKey: .regex)
           self.placeholder = try c.decodeIfPresent(RenderedPlaceholderModel.self, forKey: .placeholder)
           self.onValueChanged = try c.decodeIfPresent([RenderedActionModel].self, forKey: .onValueChanged)

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
           try c.encodeIfPresent(mask, forKey: .mask)
           try c.encodeIfPresent(rightIcon, forKey: .rightIcon)
           try c.encodeIfPresent(regex, forKey: .regex)
           try c.encodeIfPresent(placeholder, forKey: .placeholder)
           try c.encodeIfPresent(onValueChanged, forKey: .onValueChanged)

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
