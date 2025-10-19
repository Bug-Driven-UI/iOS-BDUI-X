//
//  RenderedComponent.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

public enum RenderedComponentModel: Equatable, Codable {
    case rowModel(RowModel)
    case boxModel(BoxModel)
    case columnModel(ColumnModel)
    case textModel(TextModel)
    case imageModel(ImageModel)
    case inputModel(InputModel)
    case spacerModel(SpacerModel)
    case switchModel(SwitchModel)
    case buttonModel(ButtonModel)
    
    private enum CodingKeys: String, CodingKey { case type }
    private enum Discriminator: String, Codable {
        case row, box, column, text, image, input, spacer, `switch`, button
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Discriminator.self, forKey: .type) {
        case .row: self = .rowModel(try RowModel(from: decoder))
        case .box: self = .boxModel(try BoxModel(from: decoder))
        case .column: self = .columnModel(try ColumnModel(from: decoder))
        case .text: self = .textModel(try TextModel(from: decoder))
        case .image: self = .imageModel(try ImageModel(from: decoder))
        case .input: self = .inputModel(try InputModel(from: decoder))
        case .spacer: self = .spacerModel(try SpacerModel(from: decoder))
        case .switch: self = .switchModel(try SwitchModel(from: decoder))
        case .button: self = .buttonModel(try ButtonModel(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .rowModel(let v): try v.encode(to: encoder)
        case .boxModel(let v): try v.encode(to: encoder)
        case .columnModel(let v): try v.encode(to: encoder)
        case .textModel(let v): try v.encode(to: encoder)
        case .imageModel(let v): try v.encode(to: encoder)
        case .inputModel(let v): try v.encode(to: encoder)
        case .spacerModel(let v): try v.encode(to: encoder)
        case .switchModel(let v): try v.encode(to: encoder)
        case .buttonModel(let v): try v.encode(to: encoder)
        }
    }
}
