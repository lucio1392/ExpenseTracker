//
//  ReplayBinding.swift
//  Expense Tracker
//
//  Created by Lucio on 04/08/2022.
//

import Foundation

class ReplayBinding<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    private var queue: DispatchQueue = DispatchQueue.global()
    
    func observe(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    func observe(onQueue queue: DispatchQueue, _ listener: Listener?) {
        self.queue = queue
        self.listener = listener
        queue.async { [weak self] in
            guard let `self` = self else { return }
            listener?(self.value)
        }
    }
    
    var value: T {
        didSet {
            queue.async { [weak self] in
                guard let `self` = self else { return }
                self.listener?(self.value)
            }
        }
    }
    
    func onEvent(_ value: T) {
        self.value = value
    }
    
    init(value: T) {
        self.value = value
    }
}
