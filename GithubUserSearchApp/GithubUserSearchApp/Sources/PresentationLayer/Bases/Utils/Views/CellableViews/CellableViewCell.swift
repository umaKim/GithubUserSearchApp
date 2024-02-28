//
//  CellableViewCell.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import UIKit.UICollectionViewCell

final class CellableViewCell: UICollectionViewCell {
    static let identifier = "CellableViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with view: UIView) {
        contentView.addSubviews(view)
        view.fillSuperview()
    }
}
