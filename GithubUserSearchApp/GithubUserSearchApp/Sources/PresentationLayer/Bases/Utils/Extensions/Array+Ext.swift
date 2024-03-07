//
//  Array+Ext.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/24.
//

import DomainLayer
import Foundation

public extension Array where Element == UserDomain {
    typealias ID = Int
    subscript(indexOf id: ID) -> UserDomain? {
        get {
            let index = self.firstIndex { element in
                element.id == id
            } ?? -1
            return self[safe: index]
        }
        
        set(newValue) {
            let index = self.firstIndex { element in
                element.id == id
            } ?? -1
            self[safe: index] = newValue
        }
    }
    
    subscript (contains id: Int) -> Bool {
        get {
            self.contains(where: {$0.id == id})
        }
    }
    
    var convertToDictionary: Dictionary<String, [UserDomain]> {
        return Dictionary(grouping: self, by: { String($0.name.prefix(1).uppercased()) })
    }
}

public extension Array {
    subscript (safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        
        set(newValue) {
            guard 
                let newValue = newValue,
                    indices.contains(index)
            else { return }
            
            self[index] = newValue
        }
    }
}
