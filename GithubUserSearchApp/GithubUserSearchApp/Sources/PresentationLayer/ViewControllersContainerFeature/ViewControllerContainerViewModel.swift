//
//  ViewControllerContainerViewModel.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/23.
//

import Combine
import Foundation

public protocol ViewControllerContainerInput {
    
}

public protocol ViewControllerContainerOutput {
    
}

public typealias ViewControllerContainerViewModelProtocol = ViewControllerContainerInput & ViewControllerContainerOutput

final public class ViewControllerContainerViewModel {
    private(set) lazy public var transitionPublisher: AnyPublisher<ViewControllerContainerTransition, Never> = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ViewControllerContainerTransition, Never>()
    
    public init() {}
}

extension ViewControllerContainerViewModel: ViewControllerContainerViewModelProtocol { }
