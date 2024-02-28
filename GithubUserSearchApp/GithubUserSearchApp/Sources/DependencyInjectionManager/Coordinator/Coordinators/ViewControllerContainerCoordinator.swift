//
//  ViewControllerContainerCoordinator.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/23.
//

import PresentationLayer
import Combine
import UIKit

final public class ViewControllerContainerCoordinator: Coordinator {
    private(set) lazy public var didFinishPublisher: AnyPublisher<Void, Never> = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var transitionPublisher: AnyPublisher<ViewControllerContainerTransition, Never>?
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator]
    
    private var vc: ViewControllerContainerViewController?
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    public func start() {
        let module = DependencyFactoryImp.buildViewControllerContainer()
        module
            .transitionPublisher
            .sink { transition in
                
            }
            .store(in: &cancellables)
        vc = module.viewController as? ViewControllerContainerViewController
        setChildCoordinators()
        
        guard let vc else { return }
        setRoot([vc])
    }
}

// Child Coordinator
extension ViewControllerContainerCoordinator {
    private func setChildCoordinators() {
        let userSearchCoordinator = UserSearchCoordinator(navigationController)
        userSearchCoordinator
            .didFinishPublisher
            .sink {[weak self] _ in
                self?.childCoordinators.forEach({ self?.removeChild(coordinator: $0) })
            }
            .store(in: &cancellables)
        addChild(coordinator: userSearchCoordinator)
        userSearchCoordinator.start()
        
        let localSearchCoordinator = LocalSearchCoordinator(navigationController)
        localSearchCoordinator
            .didFinishPublisher
            .sink {[weak self] _ in
                self?.childCoordinators.forEach({ self?.removeChild(coordinator: $0) })
            }
            .store(in: &cancellables)
        addChild(coordinator: localSearchCoordinator)
        localSearchCoordinator.start()
        
        let localSearchCoordinator2 = LocalSearchCoordinator(navigationController)
        localSearchCoordinator2
            .didFinishPublisher
            .sink {[weak self] _ in
                self?.childCoordinators.forEach({ self?.removeChild(coordinator: $0) })
            }
            .store(in: &cancellables)
        addChild(coordinator: localSearchCoordinator2)
        localSearchCoordinator2.start()
        
        guard
            let userSearchViewController = userSearchCoordinator.viewController as? UserSearchViewController,
            let localSearchViewController = localSearchCoordinator.viewController as? LocalSearchViewController,
            let localSearchViewController2 = localSearchCoordinator2.viewController as? LocalSearchViewController
        else { return }
        
        userSearchViewController.viewModel.listener = localSearchViewController.viewModel
        localSearchViewController.viewModel.listener = userSearchViewController.viewModel
        
        vc?.setChildViewControllers(
            userSearchViewController,
            localSearchViewController,
            localSearchViewController2
        )
    }
}
