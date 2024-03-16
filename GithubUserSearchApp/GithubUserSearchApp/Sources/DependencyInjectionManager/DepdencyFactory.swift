//
//  DepdencyFactory.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/23.
//

import PresentationLayer
import DomainLayer
import DataLayer
import UIKit

public struct DependencyFactoryImp {
    static func buildViewControllerContainer() -> Module<ViewControllerContainerTransition, UIViewController> {
        let viewModel = ViewControllerContainerViewModel()
        let viewController = ViewControllerContainerViewController(of: viewModel)
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher
        )
    }
    
    static func buildUserSearchFeature() -> Module<UserSearchTransition, UserSearchViewController> {
        let repository = UsersSearchRepositoryImp(
            urlSessionNetwork: NetworkManager(),
            persistanceManager: PersistanceStore()
        )
        let viewModel = UserSearchViewModel(
            repository: repository,
            paginator: Paginator(itemsPerPage: 30)
        )
        let viewController = UserSearchViewController(viewModel)
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher
        )
    }
    
    static func buildLocalSearchFeature() -> Module<LocalSearchTransition, LocalSearchViewController> {
        let repository = LocalSearchRepositoryImp(
            persistenceManager: PersistanceStore()
        )
        let viewModel = LocalSearchViewModel(repository: repository)
        let viewController = LocalSearchViewController(viewModel)
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher
        )
    }
}
