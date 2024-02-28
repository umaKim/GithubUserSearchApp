//
//  LocalSearchRepository.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import Combine
import Foundation

public protocol LocalSearchRepository {
    func fetchUsers() -> AnyPublisher<[UserDomain], Error>
    func saveUser(_ user: UserDomain) -> AnyPublisher<Bool, Error>
    func removeUser(_ user: UserDomain) -> AnyPublisher<Bool, Error>
}
