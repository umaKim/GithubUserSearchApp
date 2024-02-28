//
//  File.swift
//  
//
//  Created by 김윤석 on 2024/02/28.
//

import Combine
import DomainLayer
import Foundation

//protocol BaseViewModelInput {
//    func didChangeQuery(query: String)
//    func didTapStarButton(user: UserDomain)
//    func didSelectItem(at index: Int)
//}
//
//protocol BaseViewModelOutput {
//    var notifyPublisher: AnyPublisher<UserSearchNotifyType, Never> { get }
//    var users: [UserDomain] { get }
//}
//
//public class BaseViewModel {
//    public var users: [DomainLayer.UserDomain] = []
//    
//    lazy var rootPublisher = rootSubJect.eraseToAnyPublisher()
//    let rootSubJect = PassthroughSubject<Bool, Never>()
//    
//    var cancellables: Set<AnyCancellable> = .init()
//    
//    func didChangeQuery(query: String) {
//        
//    }
//    
//    public func didTapStarButton(user: DomainLayer.UserDomain) {
//        guard
//            let updatedUser = toggleFavoriteStatus(of: user)
//        else {
//            notifySubject.send(.error(DomainError.error("Toggle favorite fail")))
//            return
//        }
//        
//        let publisher = updatedUser.isFavorite
//            ? repository.saveUser(updatedUser)
//            : repository.removeUser(updatedUser)
//
//        publisher
//            .receive(on: DispatchQueue.global())
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self?.notifySubject.send(.error(.error(error.localizedDescription)))
//                }
//            }, receiveValue: { [weak self] _ in
////                self?.listener?.localSearchViewModelDidTapStarButton(updatedUser)
//                rootSubJect.send(true)
//            })
//            .store(in: &cancellables)
//    }
//    
//    func didSelectItem(at index: Int) {
//        guard let urlString = users[safe: index]?.htmlUrl else { return }
//        if let url = URL(string: urlString) {
//            transitionSubject.send(.showGitHugPage(url))
//        } else {
//            notifySubject.send(.error(DomainError.error("Invalid URL")))
//        }
//    }
//    
//    lazy var notifyPublisher: AnyPublisher<UserSearchNotifyType, Never> = notifySubject.eraseToAnyPublisher()
//    let notifySubject = PassthroughSubject<UserSearchNotifyType, Never>()
//    
//    init() {
//        
//    }
//    
//    @discardableResult
//    private func toggleFavoriteStatus(of user: UserDomain) -> UserDomain? {
//        guard var updateUser = users[indexOf: user.id] else { return nil }
//        updateUser.isFavorite.toggle()
//        users[indexOf: user.id] = updateUser
//        return updateUser
//    }
//}
