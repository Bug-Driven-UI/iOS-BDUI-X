//
//  ScreenRenderRequestModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation

struct ScreenRenderRequestModel: Codable {
    let data: Data

    struct Data: Codable {
        let screenName: String
        let variables: [String: String]?
    }
}
