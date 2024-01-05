//
//  LoginViewModel.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Combine
import Foundation

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class LoginViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    private let userInfoPublisher = PassthroughSubject<UserInfo, Never>()
    
    struct Input {
        let kakaoButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let userInfoPublisher: PassthroughSubject<UserInfo, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        
        input.kakaoButtonTapped
            .sink { _ in
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        self.setUserInfo(oauthToken: OAuthToken.init(accessToken: "", tokenType: "", refreshToken: "", scope: "", scopes: []))
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        self.setUserInfo(oauthToken: OAuthToken.init(accessToken: "", tokenType: "", refreshToken: "", scope: "", scopes: []))

                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(userInfoPublisher: userInfoPublisher)
    }
    
    func setUserInfo(oauthToken: OAuthToken) {
        let accessToken = oauthToken.accessToken
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        let userInfo = UserInfo(accessToken: accessToken)
                        self.userInfoPublisher.send(userInfo)
                    
                    } else {
                        //기타 에러
                    }
                } else {
                    self.userInfoPublisher.send(UserInfo(accessToken: UserDefaults.standard.string(forKey: "userID") ?? ""))
                }
            }
        } else {
            //로그인 필요
            let userInfo = UserInfo(accessToken: accessToken)
            self.userInfoPublisher.send(userInfo)
        }
    }
}
