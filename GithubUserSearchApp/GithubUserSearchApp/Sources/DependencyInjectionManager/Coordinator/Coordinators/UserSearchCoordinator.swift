//
//  ApiSearchCoordinator.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import SafariServices
import Combine
import UIKit
import PresentationLayer

final public class UserSearchCoordinator: Coordinator {
    private(set) lazy public var didFinishPublisher: AnyPublisher<Void, Never> = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator]
    
    private(set) var viewController: UserSearchViewController?
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    public func start() {
        let module = DependencyFactoryImp.buildUserSearchFeature()
        module
            .transitionPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] transition in
                switch transition {
                case .showGitHugPage(let url):
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc)
                }
            }
            .store(in: &cancellables)
        viewController = module.viewController
        push(module.viewController)
    }
}
