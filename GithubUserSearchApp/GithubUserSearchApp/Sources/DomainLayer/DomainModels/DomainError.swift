//
//  DomainError.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import Foundation

public enum DomainError: Error {
    case missing
    case error(String)
    
    public var description: String {
        switch self {
        case .missing:
            return "missing"
        case .error(let string):
            return string
        }
    }
}
