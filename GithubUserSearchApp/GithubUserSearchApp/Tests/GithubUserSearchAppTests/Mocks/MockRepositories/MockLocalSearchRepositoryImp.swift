//
//  MockLocalSearchRepositoryImp.swift
//
//
//  Created by 김윤석 on 2024/02/25.
//

import DomainLayer
import Combine
import Foundation

class MockLocalSearchRepository: LocalSearchRepository {
    func fetchUsers() -> AnyPublisher<[UserDomain], Error> {
        if shouldReturnError {
            return Fail(error: errorToReturn).eraseToAnyPublisher()
        } else {
            return Just(favoriteUsers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func saveUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        guard !shouldReturnError else {
            return Fail(error: errorToReturn).eraseToAnyPublisher()
        }
        if !favoriteUsers[contains: user.id] {
            favoriteUsers.append(user)
            return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func removeUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        guard !shouldReturnError else {
            return Fail(error: errorToReturn).eraseToAnyPublisher()
        }
        
        if let index = favoriteUsers.firstIndex(where: { $0.id == user.id }) {
            favoriteUsers.remove(at: index)
            return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    var favoriteUsers: [UserDomain] = MockLocalContainerDomain.users
    var shouldReturnError: Bool = false
    var errorToReturn: DomainError = .error("Mock Error")

    func addFavoriteUsers(users: [UserDomain]) {
        favoriteUsers.append(contentsOf: users)
    }

    func shouldReturnErrorOnFetch(_ flag: Bool, withError error: DomainError = .error("Mock Error")) {
        shouldReturnError = flag
        errorToReturn = error
    }
}
