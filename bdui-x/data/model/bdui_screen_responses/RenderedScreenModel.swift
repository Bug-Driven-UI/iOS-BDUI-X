//
//  RenderedScreenModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


// RenderedScreenModel.swift
import Foundation

struct RenderedScreenModel: Codable {
    let screenName: String
    let version: Int
    let components: [RenderedComponent]  
    let scaffold: RenderedScaffoldModel?
}
