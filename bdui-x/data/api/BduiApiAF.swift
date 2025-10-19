//
//  BduiApiAF.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Alamofire
import Foundation

public final class BduiApiAF: BduiApi {
    private let baseURL: URL
    private let session: Session
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(baseURL: URL,
                session: Session = .default,
                encoder: JSONEncoder = JSONEncoder(),
                decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }

    public func getRenderedScreen(
        userId: String,
        request: ScreenRenderRequestModel
    ) async -> ResultModel<RenderedScreenResponseModel> {
        let url = baseURL.appendingPathComponent("api/v1/screen/render")
        var urlRequest = URLRequest(url: url)
        urlRequest.method = .post
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(userId, forHTTPHeaderField: "userId")

        do {
            let body = try encoder.encode(request)
            urlRequest.httpBody = body
            logRequest(name: "getRenderedScreen", urlRequest: urlRequest, bodyString: prettyJSONString(data: body))

            let started = Date()
            let dataTask = session.request(urlRequest).serializingData()
            let response = await dataTask.response

            let durationMs = Int(Date().timeIntervalSince(started) * 1000)
            let status = response.response?.statusCode ?? -1
            let data = response.data ?? Data()
            let rawBody = String(data: data, encoding: .utf8) ?? "<non-utf8 \(data.count) bytes>"

            print("🛰️ [BDUI][API][HTTP] getRenderedScreen -> status=\(status) in \(durationMs)ms")
            print("    Raw body:\n\(rawBody)")

            if let error = response.error {
                print("❌ [BDUI][API][ERROR] getRenderedScreen AFError: \(error.localizedDescription)")
                return .error(error)
            }

            guard !data.isEmpty else {
                print("❌ [BDUI][API][ERROR] getRenderedScreen: Empty response body")
                return .error(nil)
            }

            do {
                let decoded = try decoder.decode(RenderedScreenResponseModel.self, from: data)
                print("✅ [BDUI][API][DECODE] getRenderedScreen OK")
                return .success(decoded)
            } catch {
                print("❌ [BDUI][API][DECODING] getRenderedScreen: \(error)")
                return .error(error)
            }
        } catch {
            logEncodingFailure(name: "getRenderedScreen", error: error, request: request)
            return .error(error)
        }
    }

    public func doAction(
        request: ScreenDoActionRequestModel
    ) async -> ResultModel<ScreenDoActionResponseModel> {
        let url = baseURL.appendingPathComponent("api/v1/screen/action")
        var urlRequest = URLRequest(url: url)
        urlRequest.method = .post
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let body = try encoder.encode(request)
            urlRequest.httpBody = body
            logRequest(name: "doAction", urlRequest: urlRequest, bodyString: prettyJSONString(data: body))

            let started = Date()
            let dataTask = session.request(urlRequest).serializingData()
            let response = await dataTask.response

            let durationMs = Int(Date().timeIntervalSince(started) * 1000)
            let status = response.response?.statusCode ?? -1
            let data = response.data ?? Data()
            let rawBody = String(data: data, encoding: .utf8) ?? "<non-utf8 \(data.count) bytes>"

            print("🛰️ [BDUI][API][HTTP] doAction -> status=\(status) in \(durationMs)ms")
            print("    Raw body:\n\(rawBody)")

            if let error = response.error {
                print("❌ [BDUI][API][ERROR] doAction AFError: \(error.localizedDescription)")
                return .error(error)
            }

            guard !data.isEmpty else {
                print("❌ [BDUI][API][ERROR] doAction: Empty response body")
                return .error(nil)
            }

            do {
                let decoded = try decoder.decode(ScreenDoActionResponseModel.self, from: data)
                print("✅ [BDUI][API][DECODE] doAction OK")
                return .success(decoded)
            } catch {
                print("❌ [BDUI][API][DECODING] doAction: \(error)")
                return .error(error)
            }
        } catch {
            logEncodingFailure(name: "doAction", error: error, request: request)
            return .error(error)
        }
    }
}

// MARK: - Logging helpers (unchanged from your previous version)
private extension BduiApiAF {
    func logRequest(name: String, urlRequest: URLRequest, bodyString: String?) {
        let method = urlRequest.httpMethod ?? "?"
        let urlStr = urlRequest.url?.absoluteString ?? "nil"
        let headers = (urlRequest.allHTTPHeaderFields ?? [:]).map { "\($0): \($1)" }.joined(separator: ", ")
        print("🛰️ [BDUI][API][REQUEST] \(name)")
        print("    URL: \(method) \(urlStr)")
        print("    Headers: [\(headers)]")
        if let bodyString {
            print("    Body:\n\(bodyString)")
        } else if let body = urlRequest.httpBody, !body.isEmpty {
            print("    Body: <\(body.count) bytes>")
        } else {
            print("    Body: <empty>")
        }
    }

    func logEncodingFailure<T: Encodable>(name: String, error: Error, request: T) {
        print("❌ [BDUI][API][ENCODING] \(name)")
        print("    Error: \(error.localizedDescription)")
        print("    Request (mirror): \(String(describing: request))")
    }

    func prettyJSONString(data: Data) -> String? {
        do {
            let obj = try JSONSerialization.jsonObject(with: data, options: [])
            let pretty = try JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
            return String(data: pretty, encoding: .utf8)
        } catch {
            return String(data: data, encoding: .utf8)
        }
    }

    func prettyJSONString<T: Encodable>(encodable: T) -> String? {
        do {
            let data = try encoder.encode(encodable)
            return prettyJSONString(data: data)
        } catch {
            return nil
        }
    }
}
