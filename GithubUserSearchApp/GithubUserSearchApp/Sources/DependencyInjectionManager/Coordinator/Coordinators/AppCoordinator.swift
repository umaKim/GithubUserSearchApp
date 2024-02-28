//
//  AppCoordinator.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import Combine
import UIKit

final public class AppCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    private(set) lazy public var didFinishPublisher: AnyPublisher<Void, Never> = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let window: UIWindow
    
    public init(
        window: UIWindow,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.window = window
        self.navigationController = navigationController
    }
    
    public func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        mainFlow()
    }
    
    private func mainFlow() {
       let coordinator = ViewControllerContainerCoordinator(navigationController)
        coordinator
            .didFinishPublisher
            .sink { _ in
                
            }
            .store(in: &cancellables)
        addChild(coordinator: coordinator)
        coordinator.start()
    }
}
