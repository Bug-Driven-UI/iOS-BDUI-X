//
//  BduiComponentInteractionsUiModel.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public struct BduiComponentInteractionsUiModel: Equatable, Codable {
    public let onClick: [BduiActionUiModel]?
    public let onShow: [BduiActionUiModel]?
    public init(onClick: [BduiActionUiModel]?, onShow: [BduiActionUiModel]?) {
        self.onClick = onClick
        self.onShow = onShow
    }
}