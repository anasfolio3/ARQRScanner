//
//  API.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Foundation
import Moya

enum API {
    static var token = ""
    static var serverUrl = ""
    case fetchRepos(page: Int, limit: Int)
}
