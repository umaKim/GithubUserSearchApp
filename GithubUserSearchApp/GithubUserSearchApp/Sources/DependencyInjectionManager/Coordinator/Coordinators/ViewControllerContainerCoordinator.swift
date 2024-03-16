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
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator]
    
    private var viewController: ViewControllerContainerViewController?
    
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
        viewController = module.viewController as? ViewControllerContainerViewController
        setChildCoordinators()
        
        guard let viewController else { return }
        setRoot([viewController])
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
        
        guard
            let userSearchViewController = userSearchCoordinator.viewController,
            let localSearchViewController = localSearchCoordinator.viewController
        else { return }
        
        userSearchViewController.viewModel.listener.addDelegate(localSearchViewController.viewModel)
        localSearchViewController.viewModel.listener.addDelegate(localSearchViewController.viewModel)
        
        viewController?.setChildViewControllers(
            userSearchViewController,
            localSearchViewController
        )
    }
}
