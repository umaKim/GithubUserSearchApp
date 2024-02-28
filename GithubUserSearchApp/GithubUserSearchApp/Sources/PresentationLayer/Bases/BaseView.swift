//
//  BaseView.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import Combine
import UIKit

class BaseView: UIView {
    var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
