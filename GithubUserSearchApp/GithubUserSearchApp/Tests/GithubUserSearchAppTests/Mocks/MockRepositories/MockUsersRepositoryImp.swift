//
//  MockUsersRepositoryImp.swift
//
//
//  Created by 김윤석 on 2024/02/25.
//

import DomainLayer
import Combine
import Foundation

final class MockUsersRepositoryImp: UsersSearchRepository {
    
    var mockUsersContainerDomain: UsersContainerDomain = MockUserContainerDomain.containerFirstPage
    
    var errorToThrow: Error?
    
    func fetchUserList(of query: String, page: Int) -> AnyPublisher<UsersContainerDomain, Error> {
        if let error = errorToThrow {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if page == 1 {
            mockUsersContainerDomain = MockUserContainerDomain.containerFirstPage
        } else if page == 2 {
            mockUsersContainerDomain = MockUserContainerDomain.containerSecondPage
        }
        
        return Just(mockUsersContainerDomain)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveFavoriteUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        if let error = errorToThrow {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            mockUsersContainerDomain.users.append(user)
            return Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func removeFavoriteUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        if let error = errorToThrow {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            mockUsersContainerDomain.users.removeAll { $0.id == user.id }
            return Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func setupMockUsersContainerDomain(_ usersContainerDomain: UsersContainerDomain) {
        self.mockUsersContainerDomain = usersContainerDomain
    }
    
    func setupMockFavoriteUsers(_ users: [UserDomain]) {
        self.mockUsersContainerDomain.users = users
    }
    
    func throwError(_ error: Error) {
        self.errorToThrow = error
    }
}
