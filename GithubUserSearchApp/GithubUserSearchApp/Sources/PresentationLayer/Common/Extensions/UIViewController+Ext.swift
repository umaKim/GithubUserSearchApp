//
//  UIViewController+Ext.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import UIKit

public extension UIViewController {
    func scrollDidEndDragging(_ scrollView: UIScrollView, completion: @escaping () -> Void) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            completion()
        }
    }
}

//MARK: - Loading View
public extension UIViewController {
    func showLoadingView() {
        let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if let loadingView = windowView?.viewWithTag(LoadingView.tagValue) as? LoadingView {
            loadingView.isLoading = true
        } else {
            let loadingView = LoadingView(frame: UIScreen.main.bounds)
            windowView?.addSubview(loadingView)
            loadingView.isLoading = true
        }
    }
    
    func hideLoadingView() {
        let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        windowView?.viewWithTag(LoadingView.tagValue)?.removeFromSuperview()
    }
}

//MARK: - Alert View
public extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
