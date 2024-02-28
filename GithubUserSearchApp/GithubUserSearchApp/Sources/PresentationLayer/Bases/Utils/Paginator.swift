//
//  Paginator.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import Foundation

public enum PaginationType {
    case lastPage
    case `continue`
}

final public class Paginator {
    private var totalItemCount: Int = 0
    public private(set) var currentPage: Int = 1
    private var itemsPerPage: Int = 0
    
    public func nextPage(_ completion: @escaping (PaginationType) -> Void) {
        if isLastPage {
            completion(.lastPage)
        } else {
            currentPage += 1
            completion(.continue)
        }
    }
    
    private var isLastPage: Bool {
        let currentItemNumbers = currentPage * itemsPerPage
        return totalItemCount <= currentItemNumbers //Unit test를 하면서 찾아낸 버그: 기존 기호 ' < ' 에서 ' <= '로 변경
    }
    
    public func setTotalItemCount(_ count: Int) {
        self.totalItemCount = count
    }
    
    public func setItemPerpage(_ itemsPerPage: Int) {
        self.itemsPerPage = itemsPerPage
    }
    
    public func reset() {
        totalItemCount = 0
        currentPage = 1
    }
    
    public init(itemsPerPage: Int) {
        self.itemsPerPage = itemsPerPage
    }
}
