//
//  MenuBarButton.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import UIKit

final public class MenuBarButton: UIButton {
    init(title: String, font: CGFloat = 20) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: font)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
