//
//  Debouncer.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import Foundation

final public class Debouncer {
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem
    
    let delay: TimeInterval
    
    public func schedule(block: @escaping () -> Void) {
        queue.async { [weak self] in
            guard let self else { return }
            
            self.workItem.cancel()
            
            let newItem = DispatchWorkItem(block: block)
            self.queue.asyncAfter(deadline: .now() + self.delay, execute: newItem)
            self.workItem = newItem
        }
    }
    
    public init(label: String, delay: TimeInterval) {
        self.queue = DispatchQueue(label: label)
        self.workItem = DispatchWorkItem(block: {})
        self.delay = delay
    }
}
