//
//  PersistanceStoreService.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import Foundation

public protocol LocalServiceProtocol {
    func save(data: Data, with key: String)
    func read(with key: String) -> Data?
}
