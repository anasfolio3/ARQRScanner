//
//  RepoTableViewCellViewModel.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 21/11/2022.
//

import Foundation

protocol RepoTableViewCellViewModelProtocol {
    var item: Item { get set }
}

class RepoTableViewCellViewModel: BaseViewModel, RepoTableViewCellViewModelProtocol {
    var item: Item

    init(item: Item) {
        self.item = item
    }
}
