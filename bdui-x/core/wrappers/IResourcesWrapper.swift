//
//  IResourcesWrapper.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation

public protocol IResourcesWrapper {
    func string(_ key: String, _ args: CVarArg...) -> String
}

public final class ResourcesWrapper: IResourcesWrapper {
    private let bundle: Bundle

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    public func string(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, bundle: bundle, comment: "")
        return String(format: format, arguments: args)
    }
}