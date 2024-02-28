//
//  UsersContainerDomain.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/24.
//

import Foundation

public struct UsersContainerDomain {
    public let totalCount: Int
    public var users: [UserDomain]
    
    public init(totalCount: Int, users: [UserDomain]) {
        self.totalCount = totalCount
        self.users = users
    }
}

public struct UserDomain: Codable, Hashable, Equatable {
    public let name: String
    public let id: Int
    public let avatarUrl: String
    public let htmlUrl: String
    public var isFavorite: Bool
    
    public init(
        name: String,
        id: Int,
        avatarUrl: String,
        htmlUrl: String,
        isFavorite: Bool
    ) {
        self.name = name
        self.id = id
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.isFavorite = isFavorite
    }
}
