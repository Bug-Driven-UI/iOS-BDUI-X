//
//  BduiComponentUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

enum BduiComponentUI: Equatable {
    case text(base: BduiComponentBaseProperties, text: BduiText)
    case image(base: BduiComponentBaseProperties, url: String)
    case button(base: BduiComponentBaseProperties, text: BduiText, enabled: Bool)
    case input(base: BduiComponentBaseProperties, text: BduiText, placeholder: BduiText?, hint: BduiText?)
    case spacer(base: BduiComponentBaseProperties)
    case column(base: BduiComponentBaseProperties, children: [BduiComponentUI])
    case row(base: BduiComponentBaseProperties, children: [BduiComponentUI])
    case box(base: BduiComponentBaseProperties, children: [BduiComponentUI])

    var base: BduiComponentBaseProperties {
        switch self {
        case .text(let b, _),
             .image(let b, _),
             .button(let b, _, _),
             .input(let b, _, _, _),
             .spacer(let b),
             .column(let b, _),
             .row(let b, _),
             .box(let b, _):

            return b
        }
    }
}
