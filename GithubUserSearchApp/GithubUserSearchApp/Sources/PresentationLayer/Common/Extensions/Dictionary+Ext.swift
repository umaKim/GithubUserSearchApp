//
//  File.swift
//  
//
//  Created by 김윤석 on 2024/02/26.
//

import DomainLayer
import UIKit
import Foundation

public extension Dictionary where Element == (key: String, value: [UserDomain]) {
    subscript (userAt indexPath: IndexPath) -> UserDomain? {
        get {
            let sectionTitles = self.keys.sorted()
            guard let sectionKey = sectionTitles[safe: indexPath.section] else { return nil }
            let usersForSection = self[sectionKey]
            return usersForSection?[indexPath.row]
        }
    }
    
    var sortedValues: Dictionary<Key, Value> {
        var newDict = Dictionary<Key, Value>()
        for (key, value) in self {
            newDict[key] = value.sorted(by: { $0.name < $1.name })
        }
        return newDict
    }
}
