//
//  ApiSearchViewModel.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import Foundation

public enum UserSearchNotifyType {
    case reload
    case reachedLastPage
    case error(DomainError)
    case loading(Bool)
}

final public class UserSearchViewModel  {
    lazy public var notifyPublisher: AnyPublisher<UserSearchNotifyType, Never> = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<UserSearchNotifyType, Never>()
    
    private(set) lazy public var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<UserSearchTransition, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private let repository: UsersSearchRepository
    
    private let paginator: Paginator
    
    private(set) public var users: [UserDomain] = []
    private var query: String = ""
    private var isLoading: Bool = false
    
    public var listener = MulticastDelegate<UserSearchViewModelListener>()
    
    public init(repository: UsersSearchRepository, paginator: Paginator) {
        self.repository = repository
        self.paginator = paginator
        self.cancellables = .init()
    }
}

//MARK: - Input from ViewController
extension UserSearchViewModel {
    public func didChangeQuery(query: String) {
        if query.isEmpty {
            resetData()
            notifySubject.send(.reload)
            return
        }
        
        guard self.query != query else { return }
        resetData()
        self.query = query
        fetchUsers(of: query)
    }
    
    public func fetchNextPage() {
        guard !users.isEmpty else { return }
        paginator.nextPage {[weak self] type in
            guard let self else { return }
            switch type {
            case .lastPage:
                notifySubject.send(.reachedLastPage)
            case .continue:
                fetchUsers(of: query)
            }
        }
    }
    
    public func didTapStarButton(user: UserDomain) {
        guard 
            let updatedUser = toggleFavoriteStatus(of: user)
        else {
            notifySubject.send(.error(DomainError.error("Toggle favorite fail")))
            return
        }
        
        let publisher = updatedUser.isFavorite 
        ? repository.saveFavoriteUser(updatedUser)
        : repository.removeFavoriteUser(updatedUser)
        
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
                self?.notifySubject.send(.reload)
                self?.listener.invokeDelegates({ listener in
                    listener.userSearchViewModelDidTapStarButton(updatedUser)
                })
            })
            .store(in: &cancellables)
    }
    
    public func didSelectItem(at index: Int) {
        guard let urlString = users[safe: index]?.htmlUrl else { return }
        if let url = URL(string: urlString) {
            transitionSubject.send(.showGitHugPage(url))
        } else {
            notifySubject.send(.error(DomainError.error("Invalid URL")))
        }
    }
}

extension UserSearchViewModel {
    private func fetchUsers(of query: String) {
        if isLoading { return }
        isLoading = true
        notifySubject.send(.loading(true))
        repository
            .fetchUserList(of: query, page: paginator.currentPage)
            .compactMap({[weak self] in
                self?.paginator.setTotalItemCount($0.totalCount)
                return $0.users
            })
            .sink {[weak self] completion in
                guard let self else { return }
                isLoading = false
                notifySubject.send(.loading(false))
                switch completion {
                case .finished:
                    notifySubject.send(.reload)
                case .failure(let error):
                    notifySubject.send(.error(.error(error.localizedDescription)))
                }
            } receiveValue: {[weak self] newUsers in
                guard let self else { return }
                self.users.append(contentsOf: newUsers)
            }
            .store(in: &cancellables)
    }
    
    @discardableResult
    private func toggleFavoriteStatus(of user: UserDomain) -> UserDomain? {
        guard var updateUser = users[indexOf: user.id] else { return nil }
        updateUser.isFavorite.toggle()
        users[indexOf: user.id] = updateUser
        return updateUser
    }
    
    private func resetData() {
        users.removeAll()
        paginator.reset()
    }
}

//MARK: - Action from LocaSearchViewmodel
extension UserSearchViewModel {
    public func localSearchViewModelDidTapStarButton(_ user: UserDomain) {
        //기존 리스트에 있다면
        if users[contains: user.id] {
            //users에 추가하고 reload
            users[indexOf: user.id] = user
            notifySubject.send(.reload)
        }
    }
}

extension UserSearchViewModel: UserSearchViewModelProtocol {}
