//
//  CellableViewControllerDatasource.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import Combine
import UIKit

final class CellableViewControllerDatasource: NSObject {
    private var cellableViewControllers: [UIViewController] = []
    var view: UIView?
    private(set) lazy var contentsOffsetPublisher = contentsOffsetSubject.eraseToAnyPublisher()
    private var contentsOffsetSubject = PassthroughSubject<CGPoint, Never>()
    
    func appendCellableView(_ viewController: UIViewController) {
        cellableViewControllers.append(viewController)
    }
}

extension CellableViewControllerDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellableViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellableViewCell.identifier,
                for: indexPath
            ) as? CellableViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: cellableViewControllers[indexPath.item].view)
        return cell
    }
}

extension CellableViewControllerDatasource: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let view else { return .init() }
        return CGSize(
            width: view.frame.width,
            height: collectionView.frame.height
        )
    }
}

extension CellableViewControllerDatasource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentsOffsetSubject.send(scrollView.contentOffset)
    }
}
