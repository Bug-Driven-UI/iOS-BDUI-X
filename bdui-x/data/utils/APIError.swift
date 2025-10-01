//
//  APIError.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum APIError: Error {
    case emptyBody
    case decoding
    case unknown
    case status(Int)
}
