//
//  LoginViewModel.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Combine
import Foundation

import KakaoSDKUser

protocol LoginViewModelInput {
    func didTappedLoginButton()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set }
    var userInfoPublisher: PassthroughSubject<UserInfo, Error> { get set }
}

protocol LoginViewModelIO: LoginViewModelInput & LoginViewModelOutput { }

class LoginViewModel: NSObject, LoginViewModelIO {
    var loginPublisher = PassthroughSubject<Void, Error>()
    var userInfoPublisher = PassthroughSubject<UserInfo, Error>()
    
    override init() {
        super.init()
    }
    
    func didTappedLoginButton() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    self.loginPublisher.send(completion: .failure(error))
                } else {
                    // 로그인 성공 시 UserInfo 객체를 생성하고, userInfoPublisher를 통해 ViewController로 전달
                    if let accessToken = oauthToken?.accessToken {
                        let userInfo = UserInfo(accessToken: accessToken)
                        self.userInfoPublisher.send(userInfo)
                    }
                    self.loginPublisher.send(completion: .finished)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    self.loginPublisher.send(completion: .failure(error))
                } else {
                    // 로그인 성공 시 UserInfo 객체를 생성하고, userInfoPublisher를 통해 ViewController로 전달
                    if let accessToken = oauthToken?.accessToken {
                        let userInfo = UserInfo(accessToken: accessToken)
                        self.userInfoPublisher.send(userInfo)
                    }
                    self.loginPublisher.send(completion: .finished)
                }
            }
        }
    }
}
