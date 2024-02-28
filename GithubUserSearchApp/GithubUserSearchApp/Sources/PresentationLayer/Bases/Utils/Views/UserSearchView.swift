//
//  UserSearchView.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import UIKit

enum UserSearchViewAction {
    case searchBarDidChange(String)
}

final class UserSearchView: BaseView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<UserSearchViewAction, Never>()
    
    private let debouncer = Debouncer(label: "debouncer", delay: 0.7)
    
    private(set) lazy var searchBarView: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Search with user name"
        tf.addTarget(self, action: #selector(searchBarDidChange), for: .editingChanged)
        return tf
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SimpleUserTableViewCell.self,
            forCellReuseIdentifier: SimpleUserTableViewCell.identifier
        )
        tableView.rowHeight = 100
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    @objc
    private func searchBarDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        debouncer.schedule {[weak self] in
            guard let self else { return }
            self.actionSubject.send(.searchBarDidChange(text))
        }
    }
    
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserSearchView {
    private func setupUI() {
        addSubviews(searchBarView, tableView)
        
        searchBarView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 16)
        )
        
        searchBarView.constrainHeight(constant: 60)
        
        tableView.anchor(
            top: searchBarView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
    }
}
