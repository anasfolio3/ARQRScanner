//
//  TrendingRepoViewController+Extensions.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit
import SkeletonView

// MARK: TableViewExtensions

extension TrendingRepoViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repo.value?.items.count ?? 0
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CellIds.repoTableViewCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellViewModel: RepoTableViewCellViewModel?

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.repoTableViewCell, for: indexPath) as? RepoTableViewCell else { fatalError("Unexpected Cell") }
        if let item = viewModel.repo.value?.items[indexPath.row] {
            cellViewModel = RepoTableViewCellViewModel(item: item)
        }
        if let cellViewModel = cellViewModel {
            cell.configure(with: cellViewModel)
        }

        return cell
    }
}

extension TrendingRepoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if !viewModel.isLoading.value, position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            viewModel.fetchRepos()
        }
    }
}
