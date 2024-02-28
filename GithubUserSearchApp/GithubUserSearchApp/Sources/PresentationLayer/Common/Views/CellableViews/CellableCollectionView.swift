//
//  CellableCollectionView.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import UIKit

final class CellableCollectionView: UICollectionView {
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CellableViewCell.self, forCellWithReuseIdentifier: CellableViewCell.identifier)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
