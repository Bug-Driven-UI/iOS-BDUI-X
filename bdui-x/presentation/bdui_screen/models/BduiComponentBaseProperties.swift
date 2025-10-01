//
//  BduiComponentBaseProperties.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

struct BduiComponentBaseProperties {
    let id: String
    let hash: String
    let interactions: BduiComponentInteractionsUI?
    let paddings: BduiComponentInsetsUI?
    let margins: BduiComponentInsetsUI?
    let width: BduiComponentSize
    let height: BduiComponentSize
    let backgroundColor: BduiColor?
    let border: BduiBorder?
    let shape: BduiShape.RoundedCorners?
}
