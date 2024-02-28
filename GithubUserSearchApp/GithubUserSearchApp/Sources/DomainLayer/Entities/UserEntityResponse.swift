//
//  UserEntityResponse.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/24.
//

import Foundation

public struct UserEntityResponse: Decodable {
    public let totalCount: Int?
    public let incompleteResults: Bool?
    public let items: [UserEntity]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

public struct UserEntity: Decodable {
    public let login: String?
    public let id: Int?
    public let avatarUrl: String?
    public let htmlUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
