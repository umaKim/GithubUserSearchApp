//
//  MenuBarView.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DomainLayer
import Combine
import UIKit.UIView

enum MenuTabBarButtonType: Int {
    case apiSearch = 0
    case localSearch = 1
}

final class MenuBarView: UIView {
    private let alignment: UIStackView.Alignment
    
    //MARK: - Init
    init(
        buttons: [UIButton],
        alignment: UIStackView.Alignment = .fill
    ) {
        self.buttons = buttons
        self.alignment = alignment
        super.init(frame: .zero)
        setupUI()
    }
    
    private var buttons = [UIButton]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectItem(at index: Int) {
        setAlpha(for: buttons[safe: index])
    }
    
    func scrollIndicator(to contentOffset: CGPoint) {
        let index = Int(contentOffset.x / frame.width)
        setAlpha(for: buttons[safe: index])
    }
    
    private func setAlpha(for button: UIButton?) {
        buttons.forEach { button in
            button.setTitleColor(.lightGray, for: .normal)
        }
        button?.setTitleColor(.black, for: .normal)
    }
    
    private func setupUI() {
        setAlpha(for: buttons[safe:0])
        
        backgroundColor = .systemBackground
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 16
        
        let totalSv = UIStackView(arrangedSubviews: [sv])
        totalSv.axis = .vertical
        totalSv.distribution = .fill
        totalSv.alignment = alignment
        
        addSubviews(totalSv)
        totalSv.fillSuperview()
    }
}
