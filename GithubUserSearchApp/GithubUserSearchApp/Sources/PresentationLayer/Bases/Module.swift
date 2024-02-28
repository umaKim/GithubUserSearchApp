//
//  Module.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/23.
//

import Combine
import UIKit

public protocol Transition {}

public struct Module<T: Transition, V: UIViewController> {
    public let viewController: V
    public let transitionPublisher: AnyPublisher<T, Never>
    
    public init(viewController: V, transitionPublisher: AnyPublisher<T, Never>) {
        self.viewController = viewController
        self.transitionPublisher = transitionPublisher
    }
}
