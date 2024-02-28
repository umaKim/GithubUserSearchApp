//
//  File.swift
//  
//
//  Created by 김윤석 on 2024/02/27.
//

import DomainLayer
import Foundation

enum MockUserContainerDomain {
    static var containerFirstPage: UsersContainerDomain = .init(
        totalCount: 10,
        users:  [
            .init(name: "AppleMan", id: 1, avatarUrl: "", htmlUrl: "AppleMan.com", isFavorite: false),
            .init(name: "iOSMan", id: 2, avatarUrl: "", htmlUrl: "iOSMan.com", isFavorite: true),
            .init(name: "Awesome", id: 3, avatarUrl: "", htmlUrl: "Awesome.com", isFavorite: true),
            .init(name: "cool", id: 4, avatarUrl: "", htmlUrl: "cool.com", isFavorite: false),
            .init(name: "3Guyman", id: 5, avatarUrl: "", htmlUrl: "3Guyman.com", isFavorite: false),
        ]
    )
    
    static var containerSecondPage: UsersContainerDomain = .init(
        totalCount: 10,
        users:  [
            .init(name: "awe", id: 6, avatarUrl: "", htmlUrl: "awe.com", isFavorite: false),
            .init(name: "uma", id: 7, avatarUrl: "", htmlUrl: "uma.com", isFavorite: true),
            .init(name: "zol", id: 8, avatarUrl: "", htmlUrl: "zol.com", isFavorite: true),
            .init(name: "makin", id: 9, avatarUrl: "", htmlUrl: "makin.com", isFavorite: false),
            .init(name: "zizy", id: 10, avatarUrl: "", htmlUrl: "zizy.com", isFavorite: false),
        ]
    )
}

enum MockLocalContainerDomain {
    static var users: [UserDomain] = [
        .init(name: "iOSMan", id: 2, avatarUrl: "", htmlUrl: "iOSMan.com", isFavorite: true),
        .init(name: "Awesome", id: 3, avatarUrl: "", htmlUrl: "Awesome.com", isFavorite: true),
        .init(name: "uma", id: 7, avatarUrl: "", htmlUrl: "uma.com", isFavorite: true),
        .init(name: "zol", id: 8, avatarUrl: "", htmlUrl: "zol.com", isFavorite: false)
    ]
}
