//
//  PersistanceStore.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import Combine
import Foundation

public struct PersistanceStore: LocalServiceProtocol {
    
    public func save(data: Data, with key: String) {
        defaults.setValue(data, forKey: key)
    }
    
    public func read(with key: String) -> Data? {
        guard 
            let data = defaults.value(forKey: key) as? Data
        else { return nil }
        return data
    }
    
    private let defaults = UserDefaults.standard
    
    public init() { }
}
