//
//  RenderedComponent.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum RenderedComponent: Codable {
    case row(Row)
    case box(Box)
    case column(Column)
    case text(TextComponent)
    case image(ImageComponent)
    case input(InputComponent)
    case spacer(SpacerComponent)
    case `switch`(SwitchComponent)
    case button(ButtonComponent)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(RenderedComponentType.self, forKey: .type)
        switch type {
        case .row:    self = .row(try Row(from: decoder))
        case .box:    self = .box(try Box(from: decoder))
        case .column: self = .column(try Column(from: decoder))
        case .text:   self = .text(try TextComponent(from: decoder))
        case .image:  self = .image(try ImageComponent(from: decoder))
        case .input:  self = .input(try InputComponent(from: decoder))
        case .spacer: self = .spacer(try SpacerComponent(from: decoder))
        case .switch: self = .switch(try SwitchComponent(from: decoder))
        case .button: self = .button(try ButtonComponent(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .row(let v):
            try container.encode(RenderedComponentType.row, forKey: .type)
            try v.encode(to: encoder)
        case .box(let v):
            try container.encode(RenderedComponentType.box, forKey: .type)
            try v.encode(to: encoder)
        case .column(let v):
            try container.encode(RenderedComponentType.column, forKey: .type)
            try v.encode(to: encoder)
        case .text(let v):
            try container.encode(RenderedComponentType.text, forKey: .type)
            try v.encode(to: encoder)
        case .image(let v):
            try container.encode(RenderedComponentType.image, forKey: .type)
            try v.encode(to: encoder)
        case .input(let v):
            try container.encode(RenderedComponentType.input, forKey: .type)
            try v.encode(to: encoder)
        case .spacer(let v):
            try container.encode(RenderedComponentType.spacer, forKey: .type)
            try v.encode(to: encoder)
        case .switch(let v):
            try container.encode(RenderedComponentType.switch, forKey: .type)
            try v.encode(to: encoder)
        case .button(let v):
            try container.encode(RenderedComponentType.button, forKey: .type)
            try v.encode(to: encoder)
        }
    }
}
