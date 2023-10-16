//
//  TrendingReposViewModelTest.swift
//  MVVMDemoTests
//
//  Created by Zayan Tharani on 25/06/2022.
//

import XCTest
@testable import MVVMDemo

class TrendingRepoViewModelTest: XCTestCase, TrendingRepoViewModelUsecase {
    var mockNetworkManager: MockNetworkManager!
    var sut: TrendingRepoViewModel!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = TrendingRepoViewModel(networkManager: mockNetworkManager)
    }

    func test_fetch_repo_success_pagination() {
        let repo = Repo(totalCount: 0, items: [Item(id: 1, name: "Dummy", fullName: "DummyRepo", owner: nil, description: nil, stargazersCount: 10, language: nil)])
        mockNetworkManager.result = .success(repo)
        sut.fetchRepos()
        XCTAssertEqual(self.sut.repo.value?.items.count, 1)
        sut.fetchRepos()
        XCTAssertEqual(self.sut.repo.value?.items.count, 2)
        XCTAssertNil(self.sut.error.value)
    }

    func test_fetch_repo_success_refresh() {
        let repo = Repo(totalCount: 0, items: [Item(id: 1, name: "Dummy", fullName: "DummyRepo", owner: nil, description: nil, stargazersCount: 10, language: nil)])
        mockNetworkManager.result = .success(repo)
        sut.fetchRepos()
        XCTAssertEqual(self.sut.repo.value?.items.count, 1)
        sut.refreshData()
        XCTAssertEqual(self.sut.repo.value?.items.count, 1)
        XCTAssertNil(self.sut.error.value)
    }

    func test_fetch_repo_failure() {
        mockNetworkManager.result = .failure(NSError(domain: "", code: -1))
        sut.fetchRepos()
        XCTAssertNotNil(self.sut.error.value)
    }
}
