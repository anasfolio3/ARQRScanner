//
//  TrendingRepoViewModelUsecase.swift
//  MVVMDemoTests
//
//  Created by Zayan Tharani on 26/06/2022.
//

import Foundation
import XCTest
@testable import MVVMDemo

///  features to test usecase methods for pinview
protocol TrendingRepoViewModelUsecase: XCTestCase {
    func test_fetch_repo_success_pagination()
    func test_fetch_repo_success_refresh()
    func test_fetch_repo_failure()
}

extension TrendingRepoViewModelUsecase {
    // MARK: GIVEN

    // MARK: WHEN

    // MARK: THEN
}
