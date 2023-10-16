//
//  API+Router.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Moya


extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.github.com/search") else { fatalError("Failed to create URL") }
        return url
    }

    var path: String {
        switch self {
        case .fetchRepos:
            return "repositories"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchRepos:
            return .get
        }
    }

    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "Accept": "application/json",
            "Client": "iphone"
        ]
    }
}
