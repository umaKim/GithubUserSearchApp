//
//  File.swift
//  
//
//  Created by 김윤석 on 2024/02/27.
//

import DomainLayer
import Combine
import Foundation

public protocol LocalSearchViewmodelListener: AnyObject {
    func localSearchViewModelDidTapStarButton(_ user: UserDomain)
}

public protocol LocalSearchViewModelInput {
    var listener: MulticastDelegate<LocalSearchViewmodelListener> { get }
    
    func onViewDidLoad()
    func didChangeQuery(query: String)
    func didTapStarButton(user: UserDomain)
    func didSelectItem(at indexIndexPath: IndexPath)
}

public protocol LocalSearchViewModelOutput {
    var notifyPublisher: AnyPublisher<UserSearchNotifyType, Never> { get }
    var usersDictionary: Dictionary<String, [UserDomain]> { get }
}

public typealias LocalSearchViewmodelProtocol = LocalSearchViewModelInput & LocalSearchViewModelOutput & UserSearchViewModelListener
