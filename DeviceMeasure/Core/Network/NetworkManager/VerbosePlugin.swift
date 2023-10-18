//
//  MoyaLogger.swift
//  AnyRoadLive
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Foundation
import Moya

/// for logging moya response and error
struct VerbosePlugin: PluginType {
    let verbose: Bool

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if verbose {
            print("request : \(request))")
        }

        if let body = request.httpBody,
           let str = String(data: body, encoding: .utf8) {
            if verbose {
                print("request  body: \(body))")
                print("request to send: \(str))")
            }
        }
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let body):
            if verbose {
                print("SUCCESS")
                print("Response ", body.response ?? "")
                print("Response Body:", body)
                print("Response:")
                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                    print(json)
                } else {
                    if let response = String(data: body.data, encoding: .utf8) {
                        print(response)
                    }
                }
            }
        case .failure(let moyaError):
            if verbose {
                print("FAILURE")
                print("Error", moyaError.errorDescription ?? "")
            }
        }
    }
}
