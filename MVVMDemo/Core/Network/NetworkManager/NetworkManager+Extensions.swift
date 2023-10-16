//
//  NetworkManager+Extensions.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Moya

extension NetworkManager {
    func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> Void) {
        getProvider().request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func requestWithNoDecoding(target: API, completion: @escaping (Result<Response, Error>) -> Void) -> Cancellable {
        return  getProvider().request(target) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
