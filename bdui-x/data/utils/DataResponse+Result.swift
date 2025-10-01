//
//  DataResponse+Result.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//

import Alamofire
import Foundation

extension DataResponse {
    func toResult() -> Result<Value> {
        if let value = value {
            return .success(value)
        }
        return .error(error)
    }
}
