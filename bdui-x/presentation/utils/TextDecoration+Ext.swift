//
//  TextDecoration+Ext.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//


import SwiftUI

extension Text {
    @ViewBuilder
    func apply(decoration: BduiTextDecorationType) -> some View {
        switch decoration {
        case .underline: self.underline()
        case .strikethrough: self.strikethrough()
        case .strikethroughRed: self.strikethrough(true, color: .red)
        case .italic: self.italic()
        case .regular: self
        }
    }
}
