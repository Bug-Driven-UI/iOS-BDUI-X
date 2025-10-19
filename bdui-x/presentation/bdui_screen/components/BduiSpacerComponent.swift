//
//  BduiSpacerComponent.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//
import SwiftUI

public struct BduiSpacerComponent: View {
    let component: BduiSpacerComponentModel

    public init(component: BduiSpacerComponentModel) {
        self.component = component
    }

    public var body: some View {
        Spacer()
    }
}
