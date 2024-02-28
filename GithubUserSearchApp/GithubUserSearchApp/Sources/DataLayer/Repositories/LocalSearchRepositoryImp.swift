//
//  LocalSearchRepository.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/24.
//

import DomainLayer
import Combine
import Foundation

final public class LocalSearchRepositoryImp: LocalSearchRepository {
    
    private let persistenceManager: LocalServiceProtocol
    
    public init(persistenceManager: LocalServiceProtocol) {
        self.persistenceManager = persistenceManager
    }
    
    public func fetchUsers() -> AnyPublisher<[UserDomain], Error> {
        guard let data = persistenceManager.read(with: UserDefaultsKey.userList.rawValue) else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        do {
            let favoriteUsers = try JSONDecoder().decode([UserDomain].self, from: data)
            return Just(favoriteUsers).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    public func saveUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        return fetchUsers()
            .flatMap {[weak self] users in
                var users = users
                users.append(user)
                return self?.saveFavoriteUsers(users) ?? Fail(error: NSError()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func removeUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        fetchUsers()
            .flatMap { [weak self] users -> AnyPublisher<Bool, Error> in
                var updatedUsers = users
                updatedUsers.removeAll { $0.id == user.id }
                return self?.saveFavoriteUsers(updatedUsers) ?? Fail(error: NSError()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension LocalSearchRepositoryImp {
    private func saveFavoriteUsers(_ users: [UserDomain]) -> AnyPublisher<Bool, Error> {
        do {
            let encodedData = try JSONEncoder().encode(users)
            persistenceManager.save(data: encodedData, with: UserDefaultsKey.userList.rawValue)
            return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
