//
//  RequestBuilder.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Foundation
import Alamofire

enum APIRoute: URLRequestConvertible {
    case getScreen(name: String)
    case submitForm(payload: FormPayload)

    var method: HTTPMethod {
        switch self {
        case .getScreen: return .get
        case .submitForm: return .post
        }
    }

    var path: String {
        switch self {
        case .getScreen(let name): return "/screen/\(name)"
        case .submitForm: return "/form/submit"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let base = URL(string: "https://hits-bdui.ru/api")!
        var request = URLRequest(url: base.appendingPathComponent(path))
        request.method = method
        switch self {
        case .getScreen:
            return request
        case .submitForm(let payload):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(AnyEncodable(payload))
            return request
        }
    }
}
protocol FormPayload : Encodable, Sendable  {}

struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void
    init(_ value: Encodable) {
        self.encodeClosure = value.encode
    }
    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
