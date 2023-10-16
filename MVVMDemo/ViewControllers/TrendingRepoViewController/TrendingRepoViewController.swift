//
//  TrendingRepoViewController.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 26/06/2022.
//

import UIKit
import SkeletonView
import Lottie

class TrendingRepoViewController: BaseViewController {
    let viewModel = TrendingRepoViewModel()
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorAnimationView: AnimationView!
    @IBOutlet weak var errorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchRepos()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.isLoading.bind { [weak self] isLoading in
            /// We'll show shimmer when there is no data and show spinner when fethcing more data
            if self?.viewModel.repo.value == nil {
                isLoading ?  self?.tableView.showAnimatedGradientSkeleton() : self?.tableView.hideSkeleton()
            } else {
                isLoading ? (self?.tableView.tableFooterView?.isHidden = false) : (self?.tableView.tableFooterView?.isHidden = true)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutSkeletonIfNeeded()
    }

    private func setupUI() {
        title = viewModel.title
        errorAnimationView.loopMode = .loop
        errorAnimationView.play()
        tableView.estimatedRowHeight = 150
        tableView.tableFooterView?.isHidden = true
        tableView.tableFooterView = createSpinnerFooter()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl

        viewModel.repo.bind { [weak self] repo in
            if repo != nil {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }

        viewModel.error.bind { [weak self] error in
            if error != nil {
                self?.errorView.isHidden = false
            }
        }
    }

    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }

    @objc private func refreshData(_ sender: Any) {
        viewModel.refreshData()
    }

    // MARK: IBActions

    @IBAction func retryButtonTapped(_ sender: Any) {
        errorView.isHidden = true
        viewModel.fetchRepos()
    }
}
