//
//  ClubHouseHandsUp.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Combine
import Foundation

class ClubHouseHandsUp: Publisher {
    // 이 Publisher는 문자열을 발행(Output)하며, 실패가 발생하지 않음(Never)을 나타냄
    typealias Output = String
    typealias Failure = Never
    
    init() {
        NSLog("ClubHouseHandsUp init")
    }
    
    // Subscriber로부터 메시지를 수신할 때 호출되는 함수
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // 전역 큐에서 유틸리티(QoS.utility) 우선순위로 비동기로 실행
        DispatchQueue.global(qos: .utility).async {
            // 더미 데이터 생성
            let dummy: [String] = ["jack", "tom"]
            // 각 더미 데이터에 대해 Subscriber에게 메시지를 전송
            dummy.forEach {
                _ = subscriber.receive($0)
            }
            // 모든 메시지 전송이 완료되면 완료(completion)를 알림
            subscriber.receive(completion: .finished)
        }
    }
}
