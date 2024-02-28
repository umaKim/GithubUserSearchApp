//
//  SimpleUserTableViewCell.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import UIKit

protocol SimpleUserTableViewCellDelegate: AnyObject {
    func userTableViewCellDidTapStarButton(user: UserDomain)
}

enum SimpleUserTableViewCellAction {
    case didTapStar(UserDomain)
}

final class SimpleUserTableViewCell: UITableViewCell {
    static let identifier = String(describing: SimpleUserTableViewCell.self)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SimpleUserTableViewCellAction, Never>()
    
    weak var delegate: SimpleUserTableViewCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let uv = UIImageView()
        uv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        uv.layer.cornerRadius = 25
        uv.backgroundColor = .clear
        uv.clipsToBounds = true
        return uv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        return lb
    }()
    
    private lazy var starButton: UIButton = {
        let bt = UIButton()
        let image = UIImage(systemName: "star")
        bt.setImage(image, for: .normal)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setStarButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var user: UserDomain?
    
    func configure(user: UserDomain) {
        self.user = user
        profileImageView.loadImage(from: user.avatarUrl)
        nameLabel.text = user.name
        starButton.setImage(.init(systemName: user.isFavorite ? "star.fill" : "star"), for: .normal)
    }
    
    private func setStarButtonAction() {
        let action = UIAction { [weak self] _ in
            guard 
                let self,
                let user
            else { return }
            delegate?.userTableViewCellDidTapStarButton(user: user)
        }
        starButton.addAction(action, for: .touchUpInside)
    }
}

extension SimpleUserTableViewCell {
    private func setupUI() {
        contentView.addSubviews(
            profileImageView,
            nameLabel,
            starButton
        )
        
        profileImageView.centerYInSuperview()
        profileImageView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
        
        nameLabel.centerYInSuperview()
        nameLabel.anchor(
            top: nil,
            leading: profileImageView.trailingAnchor,
            bottom: nil,
            trailing: starButton.leadingAnchor,
            padding: .init(
                top: 0,
                left: 16,
                bottom: 0,
                right: 0
            )
        )
        
        starButton.centerYInSuperview()
        starButton.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(
                top: 0,
                left: 0,
                bottom: 0,
                right: 16
            )
        )
        starButton.constrainWidth(constant: 50)
        starButton.constrainHeight(constant: 50)
    }
}

