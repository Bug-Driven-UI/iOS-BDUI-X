//
//  ScreenRenderRequestModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

public struct ScreenRenderRequestModel: Codable, Equatable {
    public let data: DataClass

    public init(data: DataClass) {
        self.data = data
    }

    public struct DataClass: Codable, Equatable {
        public let screenName: String
        public let variables: [String: JSONValue]?

        public init(screenName: String, variables: [String: JSONValue]? = nil) {
            self.screenName = screenName
            self.variables = variables
        }
    }
}
