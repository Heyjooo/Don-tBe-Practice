//
//  CancelBag.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Combine
import Foundation

struct CancelBag {
    private var cancellables: Set<AnyCancellable> = []

    mutating func collect(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }

    mutating func cancelAll() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
