//
//  UsersSearchRepositoryImp.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import Foundation

final public class UsersSearchRepositoryImp: UsersSearchRepository, UrlConfigurable {
    
    private let urlSessionNetwork: NetworkService
    private let persistanceManager: LocalServiceProtocol
    
    public init(
        urlSessionNetwork: NetworkService,
        persistanceManager: LocalServiceProtocol
    ) {
        self.urlSessionNetwork = urlSessionNetwork
        self.persistanceManager = persistanceManager
    }
    
    public func fetchUserList(of query: String, page: Int) -> AnyPublisher<UsersContainerDomain, Error> {
        let url = url(
            for: "https://api.github.com/search/users",
            queryParams: [
                "q": query,
                "page" : "\(page)"
            ]
        )
        return urlSessionNetwork.fetch(from: url)
            .decode(type: UserEntityResponse.self, decoder: JSONDecoder())
            .zip(fetchFavoriteUsers())
            .tryMap({ networkResponse, favoriteUsers in
                guard
                    let totalCount = networkResponse.totalCount,
                    let items = networkResponse.items
                else { throw DomainError.missing }
                
                let users = items
                    .compactMap { userEntity -> UserDomain? in
                        guard
                            let name = userEntity.login,
                            let id = userEntity.id,
                            let avatarUrl = userEntity.avatarUrl,
                            let htmlUrl = userEntity.htmlUrl
                        else { return nil }
                        
                        return UserDomain(
                            name: name,
                            id: id,
                            avatarUrl: avatarUrl,
                            htmlUrl: htmlUrl,
                            isFavorite: favoriteUsers.contains(where: {$0.id == id})
                        )
                    }
                
                return UsersContainerDomain(totalCount: totalCount, users: users)
            })
            .eraseToAnyPublisher()
    }
    
    public func saveFavoriteUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        fetchFavoriteUsers()
            .flatMap { favoriteUsers -> AnyPublisher<Bool, Error> in
                var newFavorites = favoriteUsers
                newFavorites.append(user)
                return self.saveFavoriteUsers(newFavorites)
                    .map { _ in true }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func removeFavoriteUser(_ user: UserDomain) -> AnyPublisher<Bool, Error> {
        fetchFavoriteUsers()
            .flatMap { favoriteUsers -> AnyPublisher<Bool, Error> in
                var newFavorites = favoriteUsers
                newFavorites.removeAll { $0.id == user.id }
                return self.saveFavoriteUsers(newFavorites)
            }
            .eraseToAnyPublisher()
    }
}

extension UsersSearchRepositoryImp {
    private func fetchFavoriteUsers() -> AnyPublisher<[UserDomain], Error> {
        guard let data = persistanceManager.read(with: UserDefaultsKey.userList.rawValue) else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Just(data)
            .decode(type: [UserDomain].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func saveFavoriteUsers(_ users: [UserDomain]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            do {
                let encoder = JSONEncoder()
                let encodedData = try encoder.encode(users)
                self.persistanceManager.save(data: encodedData, with: UserDefaultsKey.userList.rawValue)
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
