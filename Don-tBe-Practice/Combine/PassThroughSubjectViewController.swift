//
//  PassThroughSubjectViewController.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/4/24.
//

import Combine
import UIKit

final class PassThroughSubjectViewController: UIViewController {
    // 1. String과 Never 타입의 PassthroughSubject 객체를 생성
    let subject = PassthroughSubject<String, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2.sink를 이용하여 subscription1을 생성합니다.
        let subscription1 = subject
            .sink(
                receiveCompletion: { completion in
                      print("Received completion (1)", completion)
                },
                receiveValue: { value in
                      print("Received value (1)", value)
                }
              )
        
        // 3.sink를 이용하여 subscription2을 생성
        let subscription2 = subject
            .sink(
                receiveCompletion: { completion in
                      print("Received completion (2)", completion)
                },
                receiveValue: { value in
                      print("Received value (2)", value)
                }
              )
        
        // 4. 값을 보냄
        subject.send("Hello")
        subject.send("World")
        
        // 5. subscription1의 구독을 취소
        subscription1.cancel()
        
        // 6. 또 다른 값 전송
        subject.send("Still there?")
        
        // 7. finished라는 완료 이벤트 보냄
        subject.send(completion: .finished)
        
        // 8. 또 다른 값 전송
        subject.send("How about another one?")
        // 완료 이벤트만 찍힐 뿐 새로운 값(“How about another one?”)은 찍히지 않음. 새로운 값을 보내기 전에 send(completion:) 을 통해 완료 이벤트를 보냈기 때문 (완료 이벤트를 받으면 더 이상 다른 완료 이벤트나 값을 받지 않음)
    }
}
