//
//  UserSearchViewController.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import UIKit

final public class UserSearchViewController: UIViewController {
    private typealias DataSource    = UITableViewDiffableDataSource<Section, UserDomain>
    private typealias Snapshot      = NSDiffableDataSourceSnapshot<Section, UserDomain>
    
    enum Section { case main }
    
    private let contentView = UserSearchView()
    
    private var diffableDataSource: DataSource?
    
    public var viewModel: UserSearchViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(_ viewModel: UserSearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Life Cycle
extension UserSearchViewController {
    public override func loadView() {
        super.loadView()
        self.view = contentView
        bind()
        setupTableViewDataSource()
    }
}

//MARK: - Bind
extension UserSearchViewController {
    private func bind() {
        contentView.tableView.delegate = self
        contentView.tableView.prefetchDataSource = self
        
        contentView
            .actionPublisher
            .receive(on: DispatchQueue.main)
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
                case .reachedLastPage:
                    showAlert(title: "더이상 결과가 없습니다.", message: "")
                case .reload:
                    updateData()
                case .error(let error):
                    showAlert(title: "Error", message: error.localizedDescription)
                case .loading(let isLoading):
                    isLoading ? showLoadingView() : hideLoadingView()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Setup DataSource
extension UserSearchViewController {
    private func setupTableViewDataSource() {
        diffableDataSource = DataSource(
            tableView: contentView.tableView,
            cellProvider: {[weak self] tableView, indexPath, itemIdentifier in
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: SimpleUserTableViewCell.identifier,
                        for: indexPath
                    ) as? SimpleUserTableViewCell,
                    let self,
                    let user = viewModel.users[safe: indexPath.item]
                else { return UITableViewCell() }
                cell.delegate = self
                cell.configure(user: user)
                return cell
            }
        )
    }
    
    private func updateData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.users)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
        diffableDataSource?.defaultRowAnimation = .fade
    }
}

//MARK: - UIScrollViewDelegate
extension UserSearchViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDidEndDragging(scrollView) {[weak self] in
            self?.viewModel.fetchNextPage()
        }
    }
}

//MARK: - UITableViewDelegate
extension UserSearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath.item)
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension UserSearchViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let user = viewModel.users[safe: indexPath.row] {
                UIImageView().loadImage(from: user.avatarUrl)
            }
        }
    }
}

//MARK: - UserTableViewCellDelegate
extension UserSearchViewController: SimpleUserTableViewCellDelegate {
    func userTableViewCellDidTapStarButton(user: UserDomain) {
        viewModel.didTapStarButton(user: user)
    }
}
