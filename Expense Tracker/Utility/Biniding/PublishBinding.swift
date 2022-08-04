//
//  PublishBinding.swift
//  Expense Tracker
//
//  Created by Lucio on 04/08/2022.
//

import Foundation

class PublishBinding<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    private var queue: DispatchQueue = DispatchQueue.global()
    
    func observe(_ listener: Listener?) {
        self.listener = listener
    }
    
    func observe(onQueue queue: DispatchQueue, _ listener: Listener?) {
        self.queue = queue
        self.listener = listener
    }
    
    func onEvent(_ value: T) {
        queue.async { [weak self] in
            self?.listener?(value)
        }
    }
}
