//
//  TrendingRepoViewModel.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 26/06/2022.
//

import Foundation

protocol TrendingRepoViewModelProtocol {
    var title: String { get }
    var networkManager: APIService { get set }
    var repo: Box<Repo?> { get set }
    var error: Box<Error?> { get set }
    var isLoading: Box<Bool> { get set }
    func fetchRepos()
    func refreshData()
}

class TrendingRepoViewModel: BaseViewModel, TrendingRepoViewModelProtocol {
    var title = "Trending"
    var networkManager: APIService

    // MARK: Boxed Properties

    var repo: Box<Repo?> = Box(nil)
    var error: Box<Error?> = Box(nil)
    var isLoading = Box(false)

    init(networkManager: APIService = NetworkManager(useStubs: false)) {
        self.networkManager = networkManager
    }

    // MARK: Protocol Implementation

    func fetchRepos() {
        isLoading.value = true

        networkManager.fetchRepos(page: getPageNumber(), limit: GenericConstants.paginationLimit) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let repo):
                self?.repo.value == nil ? self?.repo.value = repo : self?.repo.value?.items.append(contentsOf: repo.items)
                self?.error.value = nil
            case .failure(let error):
                self?.error.value = error
            }
        }
    }

    func refreshData() {
        self.repo.value = nil
        fetchRepos()
    }

    // MARK: Private methods

    private func getPageNumber() -> Int {
        guard let repo = self.repo.value else { return 1 }
        return repo.items.count / GenericConstants.paginationLimit + 1
    }
}
