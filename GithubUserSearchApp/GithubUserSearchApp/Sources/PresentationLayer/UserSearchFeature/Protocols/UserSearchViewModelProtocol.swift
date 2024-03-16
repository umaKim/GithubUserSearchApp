//
//  UserSearchViewModelProtocol.swift
//
//
//  Created by 김윤석 on 2024/02/27.
//

import DomainLayer
import Combine
import Foundation

public protocol UserSearchViewModelListener: AnyObject {
    func userSearchViewModelDidTapStarButton(_ user: UserDomain)
}

public protocol UserSearchViewModelInput {
    var listener: MulticastDelegate<UserSearchViewModelListener> { get }
    
    func fetchNextPage()
    func didChangeQuery(query: String)
    func didTapStarButton(user: UserDomain)
    func didSelectItem(at index: Int)
}

public protocol UserSearchViewModelOutput {
    var notifyPublisher: AnyPublisher<UserSearchNotifyType, Never> { get }
    var users: [UserDomain] { get }
}

public typealias UserSearchViewModelProtocol = UserSearchViewModelInput & UserSearchViewModelOutput & LocalSearchViewmodelListener
