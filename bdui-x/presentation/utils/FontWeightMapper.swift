//
//  FontWeightMapper.swift
//  bdui-x
//
//  Created by dark type on 01.10.2025.
//
import SwiftUI

enum FontWeightMapper {
    static func map(_ numeric: Int) -> Font.Weight {
        switch numeric {
        case ..<250: return .ultraLight
        case 250..<350: return .light
        case 350..<450: return .regular
        case 450..<550: return .medium
        case 550..<650: return .semibold
        case 650..<750: return .bold
        case 750..<850: return .heavy
        default: return .black
        }
    }
}
