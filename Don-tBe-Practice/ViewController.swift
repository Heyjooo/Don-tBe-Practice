//
//  ViewController.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        handsupPublisher()
//        classFuture()
//        structJust()
//        structDeferred()
//        structEmpty()
//        structFail()
        structRecord()
    }
    
    // MARK: - 클럽하우스 예제
    
    private func handsupPublisher() {
        let handsupPublisher = ClubHouseHandsUp()
        _ = handsupPublisher.sink(receiveCompletion: { _ in
            print("completed")
        }) {
            print($0)
        }
    }
    
    // MARK: - 단일 이벤트와 종료 or 실패를 제공하는 publisher
    
    private func classFuture() {
        let future = Future<String, Error> { promise in
            promise(.success("jack"))
        }
        _ = future.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
        
        let futureWithError = Future<String, Error> { promise in
            promise(.failure(NSError(domain: "error", code: -1, userInfo: nil)))
        }
        _ = futureWithError.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
        
        // sink를 completion 블럭 없이 사용 가능
        let futureWithNever = Future<String, Never> { promise in
            promise(.success("jack"))
        }
        _ = futureWithNever.sink {
            print($0)
        }
    }
    
    // MARK: - 단일 이벤트 발생 후 종료되는 publisher
    
    private func structJust() {
        let just = Just<String>("jack")
        _ = just.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
    }
    
    // MARK: - 구독이 "이루어질 때" publisher가 만들어질 수 있도록 하는 publisher
    
    private func structDeferred() {
        let deferred = Deferred<ClubHouseHandsUp>{ () -> ClubHouseHandsUp in
            return ClubHouseHandsUp()
        }
        print("deferrd init")
        _ = deferred.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
    }
    
    // MARK: - 이벤트 없이 종료되는 publisher
    
    private func structEmpty() {
        let empty = Empty<String, Never>()
        _ = empty.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
    }
    
    // MARK: - 오류와 함께 종료되는 publisher
    
    private func structFail() {
        let failed = Fail<String, Error>(error: NSError(domain: "error", code: -1, userInfo: nil))
        _ = failed.sink {
          print($0)
        } receiveValue: {
          print($0)
        }
    }
    
    // MARK: - 입력과 완료를 기록하여 다른 subscriber에서 반복될 수 있는 publisher
    
    private func structRecord() {
        let record = Record<String, Error> { recoding in
            print("make recording")
            recoding.receive("jack")
            recoding.receive("tom")
            recoding.receive(completion: .finished)
        }
        _ = record.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
        _ = record.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
    }
}

