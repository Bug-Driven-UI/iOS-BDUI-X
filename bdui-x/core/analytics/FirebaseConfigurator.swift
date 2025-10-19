//
//  FirebaseConfigurator.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation
import FirebaseCore

public enum FirebaseConfigurator {
    public static func configure() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}
