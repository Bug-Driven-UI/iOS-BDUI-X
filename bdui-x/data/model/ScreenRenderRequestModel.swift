//
//  ScreenRenderRequestModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

struct ScreenRenderRequestModel: Codable, Equatable {
    let data: Data

    struct Data: Codable, Equatable {
        let screenName: String
        let variables: [String: JSONValue]?
    }
}
