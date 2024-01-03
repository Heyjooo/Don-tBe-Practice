//
//  ViewModelType.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/4/24.
//

import Combine
import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output
}
