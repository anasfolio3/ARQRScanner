//
//  RepoModel.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 25/06/2022.
//

import Foundation

// MARK: - Repo
struct Repo: Codable {
    let totalCount: Int
    var items: [Item]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let name, fullName: String
    let owner: Owner?
    let description: String?
    let stargazersCount: Int?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case owner
        case description
        case stargazersCount = "stargazers_count"
        case language
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}
