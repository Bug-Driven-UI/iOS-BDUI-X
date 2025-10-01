//
//  APISession.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Alamofire
import Foundation

final class APISession {
    static let shared = APISession()

    private let session: Session
    private let jsonDecoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.jsonDecoder = decoder
    }

    func requestDecodable<T: Decodable>(_ convertible: URLRequestConvertible) async -> Result<T> {
        do {
            let value = try await session
                .request(convertible)
                .validate()
                .serializingDecodable(T.self, decoder: jsonDecoder)
                .value
            return .success(value)
        } catch {
            return .error(error)
        }
    }

    func requestCompletable(_ convertible: URLRequestConvertible) async -> Result<Completable> {
        let response = await session
            .request(convertible)
            .serializingData()
            .response

        guard let status = response.response?.statusCode else {
            return .error(APIError.unknown)
        }

        if (200 ..< 300).contains(status) {
            if status == 204 {
                return .success(.instance)
            }

            return .success(.instance)
        } else {
            return .error(APIError.status(status))
        }
    }
}
