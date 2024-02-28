//
//  ViewControllerContainerView.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import UIKit
import Combine

final class ViewControllerContainerView: BaseView {
    //MARK: - UI Objects
    private let apiSearchButton: MenuBarButton = MenuBarButton(title: "API")
    private let localSearchButton: MenuBarButton = MenuBarButton(title: "Local")
    
    private(set) lazy var menuTabBar = MenuBarView(
        buttons: [apiSearchButton, localSearchButton],
        alignment: .fill
    )
    private(set) lazy var collectionView = CellableCollectionView()
    
    //MARK: - Init
    override init() {
        super.init()
        setupUI()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewControllerContainerView {
    private func setupButtonActions() {
        let apiSearchButtonAction = UIAction {[weak self] _ in
            guard let self else { return }
            scroll(to: .apiSearch)
        }
        
        let localSearchButtonAction = UIAction {[weak self] _ in
            guard let self else { return }
            scroll(to: .localSearch)
        }
        
        apiSearchButton.addAction(apiSearchButtonAction, for: .touchUpInside)
        localSearchButton.addAction(localSearchButtonAction, for: .touchUpInside)
    }
    
    private func scroll(to item: MenuTabBarButtonType) {
        let indexPath = IndexPath(item: item.rawValue, section: 0)
        self.collectionView.scrollToItem(
            at: indexPath,
            at: [],
            animated: true
        )
    }
}

//MARK: - Set up UI
extension ViewControllerContainerView {
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews(menuTabBar, collectionView)
        
        menuTabBar.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 16)
        )
        menuTabBar.constrainHeight(constant: 50)
        
        collectionView.anchor(
            top: menuTabBar.bottomAnchor,
            leading: leadingAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            trailing: trailingAnchor
        )
    }
}
