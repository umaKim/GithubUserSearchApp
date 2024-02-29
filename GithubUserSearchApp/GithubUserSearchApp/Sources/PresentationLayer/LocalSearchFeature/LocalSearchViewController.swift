//
//  LocalSearchViewController.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import UIKit

final public class LocalSearchViewController: UIViewController {
    private typealias DataSource    = UserSectionShowableDataSource
    private typealias Snapshot      = NSDiffableDataSourceSnapshot<String, UserDomain>
    
    private let contentView = UserSearchView()
    
    private var diffableDataSource: DataSource?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    public var viewModel: LocalSearchViewmodelProtocol
    
    public init(_ viewModel: LocalSearchViewmodelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Life Cycle
extension LocalSearchViewController {
    public override func loadView() {
        super.loadView()
        self.view = contentView
        bind()
        setupTableViewDataSource()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

//MARK: - Bind
extension LocalSearchViewController {
    private func bind() {
        contentView.tableView.delegate = self
        
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self else { return }
                switch action {
                case .searchBarDidChange(let text):
                    viewModel.didChangeQuery(query: text)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] notify in
                guard let self else { return }
                switch notify {
                case .loading(let isLoading):
                    isLoading ? showLoadingView() : hideLoadingView()
                case .error(let error):
                    showAlert(title: "Error", message: error.localizedDescription)
                case .reachedLastPage:
                    showAlert(title: "마지막 페이이지 입니다.", message: "")
                case .reload:
                    updateData()
                }
            }
            .store(in: &cancellables)
    } }

//MARK: - Setup DataSource
extension LocalSearchViewController {
    private func setupTableViewDataSource() {
        contentView.tableView.prefetchDataSource = self
        diffableDataSource = UserSectionShowableDataSource(
            tableView: contentView.tableView,
            cellProvider: {[weak self] tableView, indexPath, itemIdentifier in
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: SimpleUserTableViewCell.identifier,
                        for: indexPath
                    ) as? SimpleUserTableViewCell,
                    let self,
                    let user = viewModel.usersDictionary[userAt: indexPath]
                else { return UITableViewCell() }
                cell.delegate = self
                cell.configure(user: user)
                return cell
            }
        )
    }
    
    private func updateData() {
        diffableDataSource?.usersDictionary = viewModel.usersDictionary
        var snapshot = Snapshot()
        let groupedUsers = viewModel.usersDictionary
        let sortedKeys = groupedUsers.keys.sorted()
        sortedKeys.forEach { key in
            snapshot.appendSections([key])
            if let usersForSection = groupedUsers[key] {
                snapshot.appendItems(usersForSection, toSection: key)
            }
        }
        diffableDataSource?.defaultRowAnimation = .fade
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UITableViewDelegate
extension LocalSearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath)
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension LocalSearchViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let user = viewModel.usersDictionary[userAt: indexPath] {
                UIImageView().loadImage(from: user.avatarUrl)
            }
        }
    }
}

//MARK: - UserTableViewCellDelegate
extension LocalSearchViewController: SimpleUserTableViewCellDelegate {
    func userTableViewCellDidTapStarButton(user: UserDomain) {
        viewModel.didTapStarButton(user: user)
    }
}
