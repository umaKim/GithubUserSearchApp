//
//  ViewControllerContainerViewController.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/23.
//

import Combine
import UIKit

final public class ViewControllerContainerViewController: UIViewController {
    private var cellableDataSource = CellableViewControllerDatasource()
    private let contentView = ViewControllerContainerView()
    private var cancellables: Set<AnyCancellable>
    
    private let viewModel: ViewControllerContainerViewModelProtocol
    
    public init(of viewModel: ViewControllerContainerViewModelProtocol) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Life cyle
extension ViewControllerContainerViewController {
    public override func loadView() {
        super.loadView()
        title = "GitHub User Star"
        view = contentView
        cellableDataSource.view = view
        contentView.collectionView.dataSource   = cellableDataSource
        contentView.collectionView.delegate     = cellableDataSource
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewControllerContainerViewController {
    private func bind() {
        cellableDataSource
            .contentsOffsetPublisher
            .sink {[weak self] contentsOffset in
                self?.contentView
                    .menuTabBar
                    .scrollIndicator(to: contentsOffset)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Set up Views
extension ViewControllerContainerViewController {
    public func setChildViewControllers(_ viewControllers: UIViewController...) {
        viewControllers.forEach { vc in
            cellableDataSource.appendCellableView(vc)
        }
    }
}
