//
//  BduiComponentInsetsUI.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//

import SwiftUI

struct BduiComponentInsetsUI: Equatable {
    let start: CGFloat
    let end: CGFloat
    let top: CGFloat
    let bottom: CGFloat

    var edgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: start, bottom: bottom, trailing: end)
    }
}
