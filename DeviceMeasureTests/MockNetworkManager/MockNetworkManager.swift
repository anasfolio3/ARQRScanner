//
//  File.swift
//  DeviceMeasureTests
//
//  Created by Zayan Tharani on 26/06/2022.
//

import Foundation
import Moya
@testable import DeviceMeasure


class MockNetworkManager: APIService {
    var result: Result<Repo, Error>?

    func fetchRepos(page: Int, limit: Int, completion: @escaping (Result<Repo, Error>) -> Void) {
        guard let result = result else { fatalError("Expected result not defined") }
        completion(result)
    }
}
