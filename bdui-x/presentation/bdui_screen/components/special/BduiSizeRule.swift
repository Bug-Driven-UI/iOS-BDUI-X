//
//  BduiSizeRule.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//
import SwiftUI

public enum BduiSizeRule: Equatable {
    case fixed(CGFloat)
    case wrap
    case matchParent
    case weighted(CGFloat)
}

@available(iOS 16.0, *)
public struct BduiWidthRuleKey: LayoutValueKey {
    public static let defaultValue: BduiSizeRule = .wrap
}

@available(iOS 16.0, *)
public struct BduiHeightRuleKey: LayoutValueKey {
    public static let defaultValue: BduiSizeRule = .wrap
}

public extension View {
    @ViewBuilder
    func bduiWidthRule(_ rule: BduiSizeRule) -> some View {
        if #available(iOS 16.0, *) {
            self.layoutValue(key: BduiWidthRuleKey.self, value: rule)
        } else {
            
            switch rule {
            case .fixed(let w):
                self.frame(width: w)
            case .matchParent:
                self.frame(maxWidth: .infinity)
            case .weighted:
                
                self.frame(maxWidth: .infinity)
            case .wrap:
                self
            }
        }
    }

    @ViewBuilder
    func bduiHeightRule(_ rule: BduiSizeRule) -> some View {
        if #available(iOS 16.0, *) {
            self.layoutValue(key: BduiHeightRuleKey.self, value: rule)
        } else {
            
            switch rule {
            case .fixed(let h):
                self.frame(height: h)
            case .matchParent, .weighted, .wrap:
                
                self
            }
        }
    }
}
