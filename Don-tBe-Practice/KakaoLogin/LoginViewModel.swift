//
//  LoginViewModel.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Combine
import Foundation

import KakaoSDKUser

final class LoginViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    
    struct Input {
        let kakaoButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let userInfoPublisher: PassthroughSubject<UserInfo, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let userInfoPublisher = PassthroughSubject<UserInfo, Never>()
        
        input.kakaoButtonTapped
            .sink { _ in
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error {
                            print(error)
                        } else {
                            // 로그인 성공 시 UserInfo 객체를 생성하고, userInfoPublisher를 통해 ViewController로 전달
                            if let accessToken = oauthToken?.accessToken {
                                let userInfo = UserInfo(accessToken: accessToken)
                                userInfoPublisher.send(userInfo)
                            }
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        if let error {
                            print(error)
                        } else {
                            // 로그인 성공 시 UserInfo 객체를 생성하고, userInfoPublisher를 통해 ViewController로 전달
                            if let accessToken = oauthToken?.accessToken {
                                let userInfo = UserInfo(accessToken: accessToken)
                                userInfoPublisher.send(userInfo)
                            }
                        }
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(userInfoPublisher: userInfoPublisher)
    }
}
