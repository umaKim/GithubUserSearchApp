//
//  LocalSearchViewModel.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import Foundation

final public class LocalSearchViewModel {
    
    private(set) lazy public var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<LocalSearchTransition, Never>()
    
    public lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<UserSearchNotifyType, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private var users: [UserDomain] = [] {
        didSet {
            updateFilteredUsers()
        }
    }
    private var query = "" {
        didSet {
            updateFilteredUsers()
        }
    }
    
    public var listener = MulticastDelegate<LocalSearchViewmodelListener>()
    
    public private(set) var usersDictionary: [String: [UserDomain]] = [:]
    private let repository: LocalSearchRepository
    
    public init(repository: LocalSearchRepository) {
        self.repository = repository
        self.cancellables = .init()
    }
}

// MARK: - Input from ViewController
extension LocalSearchViewModel {
    public func onViewDidLoad() {
        fetchUsers()
    }
    
    public func didChangeQuery(query: String) {
        guard self.query != query else { return }
        self.query = query
    }
    
    public func didTapStarButton(user: UserDomain) {
        guard
            let updatedUser = toggleFavoriteStatus(of: user)
        else {
            notifySubject.send(.error(DomainError.error("Toggle favorite fail")))
            return
        }
        
        let publisher = updatedUser.isFavorite
            ? repository.saveUser(updatedUser)
            : repository.removeUser(updatedUser)

        publisher
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.notifySubject.send(.error(.error(error.localizedDescription)))
                }
            }, receiveValue: { [weak self] _ in
                self?.listener.invokeDelegates({ listener in
                    listener.localSearchViewModelDidTapStarButton(updatedUser)
                })
            })
            .store(in: &cancellables)
    }
    
    public func didSelectItem(at indexPath: IndexPath) {
        guard let urlString = usersDictionary[userAt: indexPath]?.htmlUrl else { return }
        if let url = URL(string: urlString) {
            transitionSubject.send(.showGitHugPage(url))
        } else {
            notifySubject.send(.error(DomainError.error("Invalid URL")))
        }
    }
}

// MARK: - Private Methods
private extension LocalSearchViewModel {
    private func fetchUsers() {
        repository
            .fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.notifySubject.send(.error(.error(error.localizedDescription)))
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
    
    private func updateFilteredUsers() {
        let filteredUsers = query.isEmpty ? users : users.filter { $0.name.lowercased().contains(query.lowercased()) }
        usersDictionary = filteredUsers.convertToDictionary.sortedValues
        notifySubject.send(.reload)
    }
    
    @discardableResult
    private func toggleFavoriteStatus(of user: UserDomain) -> UserDomain? {
        guard var updateUser = users[indexOf: user.id] else { return nil }
        updateUser.isFavorite.toggle()
        users[indexOf: user.id] = updateUser
        return updateUser
    }
}

// MARK: - UserSearchViewModelListener
extension LocalSearchViewModel {
    public func userSearchViewModelDidTapStarButton(_ user: UserDomain) {
        //기존 리스트에 있다면
        if users[contains: user.id] {
            //users에 추가하고 reload
            users[indexOf: user.id] = user
            notifySubject.send(.reload)
        } else {
            users.append(user)
        }
    }
}

extension LocalSearchViewModel: LocalSearchViewmodelProtocol { }
