//
//  NetworkManager.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Moya

class NetworkManager: Networkable {
    /// if we don;t want to mock a certain api we can pass false here
    private let useStubs: Bool
    private let dispatchQueue: DispatchQueue?

    /// initializer for our moya client
    /// - Parameters:
    ///   - test: if test is true then our stub is going to be called
    ///   - callbackQueue: if thread provided our response will,be on that particular thread , by default it will be on the main thread
    public init(useStubs: Bool, callbackQueue: DispatchQueue? = .none) {
        self.useStubs = useStubs
        self.dispatchQueue = callbackQueue
    }

    // MARK: Setup
    func getProvider() -> MoyaProvider<API> {
        return MoyaProvider<API>(callbackQueue: self.dispatchQueue, plugins: [VerbosePlugin(verbose: false)])
    }

    // MARK: API Calls
    func fetchRepos(page: Int, limit: Int, completion: @escaping (Result<Repo, Error>) -> Void) {
        request(target: .fetchRepos(page: page, limit: limit), completion: completion)
    }
}
