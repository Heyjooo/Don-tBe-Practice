//
//  PassThroughSubjectViewController.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/4/24.
//

import Combine
import UIKit

final class SubjectViewController: UIViewController {
    // 1. String과 Never 타입의 PassthroughSubject 객체를 생성
    let subject = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    let testSubject = PassthroughSubject<Int, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passThroughSubject()
        currentValueSubject()
        eraseType()
    }
    
    private func passThroughSubject() {
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
    
    private func currentValueSubject() {
        // 1. Int와 Never 타입을 갖는 CurrentValueSubject를 생성
        // 1-1. CurrentValueSubject는 반드시 초기값이 있어야함
        let subject = CurrentValueSubject<Int, Never>(0)
        
        // 2. sink를 통해 subject를 구독, Failure Type이 Never일때 receiveCompletion은 생략 가능
        subject
            .sink(receiveValue: { print($0) })
            .store(in: &subscriptions) // 3. subcription을 subscriptions 묶음에 저장
            // in 안에 들어가는 parameter 타입은 Set<AnyCancellable> 으로 이곳에 여러 subscription을 저장할 수 있음. 저장된 subscription들은 해당 set이 초기화 해체(deinitialized)될 때 같이 자동으로 취소됨      => 관리 쉬움

        subject.send(1)
        subject.send(2)
        
        print(subject.value)
        
        subject.value = 3
        
        // subject.value = .finished처럼 완료 이벤트는 value 속성 값 할당을 통해 주입할 수 없음. 오직 값만 주입 가능
        // 완료 이벤트를 발행하고 싶으면 PassthroughSubject 와 같은 방법을 사용하면 됨
        subject.send(completion: .finished)

    }
    
    private func eraseType() {
        // subscrbier가 publisher에 대한 세부정보에 접근하지 않으면서 이벤트를 구독 하려는 상황에서
        // eraseToAnyPublisher() 통해 subject를 AnyPublisher<Int, Never> 으로 만들어주면
        // 해당 publisher가 PassthroughSubject 였다는 사실을 숨길 수 있음
        // AnyPublisher는 send(_:) 가 없기 때문에 publisher에 값을 추가할 수는 없음
        let publisher = testSubject.eraseToAnyPublisher()
    }
}
