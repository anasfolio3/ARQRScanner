//
//  APIService.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Foundation
import Moya

protocol APIService {
    func fetchRepos(page: Int, limit: Int, completion: @escaping (Result<Repo, Error>) -> Void)
}

/// add your network requests here inside the protocol
protocol Networkable: APIService {
    func getProvider() -> MoyaProvider<API>
}
