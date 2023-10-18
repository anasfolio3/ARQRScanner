//
//  API+Builder.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Moya

extension API {
    var task: Task {
        switch self {
        case let .fetchRepos(page, limit):
            return .requestParameters(parameters: ["q": "language+sort:stars", "page": "\(page)", "per_page": "\(limit)"], encoding: URLEncoding.default)
        }
    }
}
