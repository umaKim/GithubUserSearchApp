//
//  UsersSearchRepository.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import Combine
import Foundation

public protocol UsersSearchRepository {
    func fetchUserList(of query: String, page: Int) -> AnyPublisher<UsersContainerDomain, Error>
    func saveFavoriteUser(_ user: UserDomain) -> AnyPublisher<Bool, Error>
    func removeFavoriteUser(_ user: UserDomain) -> AnyPublisher<Bool, Error>
}
