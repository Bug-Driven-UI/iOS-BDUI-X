//
//  JSONValue.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

enum JSONValue: Codable, Equatable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() { self = .null }
        else if let b = try? c.decode(Bool.self) { self = .bool(b) }
        else if let n = try? c.decode(Double.self) { self = .number(n) }
        else if let s = try? c.decode(String.self) { self = .string(s) }
        else if let a = try? c.decode([JSONValue].self) { self = .array(a) }
        else if let o = try? c.decode([String: JSONValue].self) { self = .object(o) }
        else {
            throw DecodingError.typeMismatch(JSONValue.self,
                                             .init(codingPath: decoder.codingPath,
                                                   debugDescription: "Unsupported JSON value"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .null: try c.encodeNil()
        case .bool(let v): try c.encode(v)
        case .number(let v): try c.encode(v)
        case .string(let v): try c.encode(v)
        case .array(let v): try c.encode(v)
        case .object(let v): try c.encode(v)
        }
    }
}
extension JSONValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .null:
            hasher.combine(0)
        case .bool(let v):
            hasher.combine(1); hasher.combine(v)
        case .number(let v):
            hasher.combine(2); hasher.combine(v)
        case .string(let v):
            hasher.combine(3); hasher.combine(v)
        case .array(let arr):
            hasher.combine(4)
            hasher.combine(arr.count)
            arr.forEach { hasher.combine($0) }
        case .object(let dict):
            hasher.combine(5)
            
            for key in dict.keys.sorted() {
                hasher.combine(key)
                hasher.combine(dict[key])
            }
        }
    }
}

extension JSONValue {
    var string: String? {
        if case .string(let v) = self { return v }
        return nil
    }
    var double: Double? {
        if case .number(let v) = self { return v }
        return nil
    }
    var bool: Bool? {
        if case .bool(let v) = self { return v }
        return nil
    }
    var array: [JSONValue]? {
        if case .array(let v) = self { return v }
        return nil
    }
    var object: [String: JSONValue]? {
        if case .object(let v) = self { return v }
        return nil
    }
    var isNull: Bool {
        if case .null = self { return true }
        return false
    }
}

// Конвертация любого Encodable в JSONValue (через JSONSerialization)
extension JSONValue {
    static func fromEncodable(_ value: Encodable,
                              encoder: JSONEncoder = JSONEncoder()) throws -> JSONValue {
        let data = try encoder.encode(AnyEncodable(value))
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return try JSONValue.fromAny(json)
    }

    private static func fromAny(_ any: Any) throws -> JSONValue {
        switch any {
        case is NSNull:
            return .null
        case let v as String:
            return .string(v)
        case let v as NSNumber:
            // NSNumber может быть Bool/Number
            if CFGetTypeID(v) == CFBooleanGetTypeID() {
                return .bool(v.boolValue)
            }
            return .number(v.doubleValue)
        case let v as [Any]:
            return .array(try v.map { try .fromAny($0) })
        case let v as [String: Any]:
            var obj: [String: JSONValue] = [:]
            for (k, val) in v {
                obj[k] = try .fromAny(val)
            }
            return .object(obj)
        default:
            throw NSError(domain: "JSONValue",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Unsupported type \(type(of: any))"])
        }
    }
}
